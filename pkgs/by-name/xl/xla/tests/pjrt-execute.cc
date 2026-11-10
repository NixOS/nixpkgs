// Exercise the installed plugin through the C ABI, without linking XLA or JAX.
#include <dlfcn.h>

#include <array>
#include <cmath>
#include <cstring>
#include <functional>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>

#include "xla/pjrt/c/pjrt_c_api.h"

#define ARGS(type, name)                                                       \
  type name{};                                                                 \
  name.struct_size = type##_STRUCT_SIZE
#define CALL(name, args) check(api, api->name(&args), #name)

static bool cleanup_failed = false;

static void require(bool condition, const std::string &message) {
  if (!condition)
    throw std::runtime_error(message);
}

static void check(const PJRT_Api *api, PJRT_Error *error,
                  const char *operation) {
  if (!error)
    return;
  ARGS(PJRT_Error_Message_Args, message);
  message.error = error;
  api->PJRT_Error_Message(&message);
  std::string text(message.message, message.message_size);
  ARGS(PJRT_Error_Destroy_Args, destroy);
  destroy.error = error;
  api->PJRT_Error_Destroy(&destroy);
  throw std::runtime_error(std::string(operation) + ": " + text);
}

// Keep plugin resources alive until their asynchronous users have completed.
// Destruction errors must fail the test too, but must not throw during
// unwinding.
template <typename T, typename Args>
static auto own(const PJRT_Api *api, T *object, PJRT_Error *(*destroy)(Args *),
                size_t struct_size) {
  return std::unique_ptr<T, std::function<void(T *)>>(object, [=](T *value) {
    Args args{struct_size, nullptr, value};
    try {
      check(api, destroy(&args), "resource destruction");
    } catch (const std::exception &error) {
      std::cerr << "FAIL: " << error.what() << '\n';
      cleanup_failed = true;
    }
  });
}
#define OWN(kind, object)                                                      \
  own(api, object, api->kind##_Destroy, kind##_Destroy_Args_STRUCT_SIZE)

static void await(const PJRT_Api *api, PJRT_Event *event) {
  require(event != nullptr, "missing asynchronous completion event");
  auto owned = OWN(PJRT_Event, event);
  ARGS(PJRT_Event_Await_Args, args);
  args.event = event;
  CALL(PJRT_Event_Await, args);
}

static auto upload(const PJRT_Api *api, PJRT_Client *client,
                   PJRT_Device *device, const std::array<float, 6> &data) {
  const int64_t dims[] = {2, 3};
  ARGS(PJRT_Client_BufferFromHostBuffer_Args, args);
  args.client = client;
  args.device = device;
  args.data = data.data();
  args.type = PJRT_Buffer_Type_F32;
  args.dims = dims;
  args.num_dims = 2;
  args.host_buffer_semantics =
      PJRT_HostBufferSemantics_kImmutableOnlyDuringCall;
  CALL(PJRT_Client_BufferFromHostBuffer, args);
  auto buffer = OWN(PJRT_Buffer, args.buffer);
  await(api, args.done_with_host_buffer);
  return buffer;
}

static void run(const char *plugin, const std::string &platform,
                bool wrong_expected) {
  auto close_plugin = [](void *handle) { dlclose(handle); };
  // XLA retains process-global thread pools and exit hooks after client
  // destruction. Release the dlopen handle, but do not unmap their code.
  std::unique_ptr<void, decltype(close_plugin)> handle(
      dlopen(plugin, RTLD_NOW | RTLD_LOCAL | RTLD_NODELETE), close_plugin);
  if (!handle)
    throw std::runtime_error(std::string("dlopen: ") + dlerror());
  auto get_api = reinterpret_cast<const PJRT_Api *(*)()>(
      dlsym(handle.get(), "GetPjrtApi"));
  require(get_api != nullptr, "GetPjrtApi not exported");
  const PJRT_Api *api = get_api();
  require(api != nullptr, "GetPjrtApi returned null");
  require(api->pjrt_api_version.major_version == PJRT_API_MAJOR &&
              api->pjrt_api_version.minor_version >= PJRT_API_MINOR &&
              api->struct_size >= PJRT_Api_STRUCT_SIZE,
          "plugin C API is older than or incompatible with the test headers");
  std::cout << "Loaded PJRT API " << api->pjrt_api_version.major_version << '.'
            << api->pjrt_api_version.minor_version << '\n';

  ARGS(PJRT_Plugin_Initialize_Args, initialize);
  CALL(PJRT_Plugin_Initialize, initialize);
  std::cout << "Plugin initialized\n";
  ARGS(PJRT_Client_Create_Args, create);
  CALL(PJRT_Client_Create, create);
  auto client = OWN(PJRT_Client, create.client);
  require(client != nullptr, "null client");
  std::cout << "Client created\n";

  ARGS(PJRT_Client_PlatformName_Args, name);
  name.client = client.get();
  CALL(PJRT_Client_PlatformName, name);
  std::string actual_platform(name.platform_name, name.platform_name_size);
  std::cout << "Platform: " << actual_platform << '\n';
  require(actual_platform == platform,
          "requested platform " + platform + ", got " + actual_platform);
  ARGS(PJRT_Client_AddressableDevices_Args, devices);
  devices.client = client.get();
  CALL(PJRT_Client_AddressableDevices, devices);
  require(devices.num_addressable_devices > 0, "no addressable devices");
  std::cout << "Addressable devices: " << devices.num_addressable_devices
            << '\n';

  // Inputs are host buffers, not constants in the compiled module.
  char module[] = R"mlir(
module @pjrt_execute {
  func.func @main(%x: tensor<2x3xf32>, %y: tensor<2x3xf32>) -> (tensor<2x3xf32>, tensor<2x3xf32>) {
    %sum = stablehlo.add %x, %y : tensor<2x3xf32>
    %result = stablehlo.multiply %sum, %x : tensor<2x3xf32>
    %transcendental = stablehlo.sine %sum : tensor<2x3xf32>
    return %result, %transcendental : tensor<2x3xf32>, tensor<2x3xf32>
  }
}
)mlir";
  ARGS(PJRT_Program, program);
  program.code = module;
  program.code_size = std::strlen(module);
  program.format = "mlir";
  program.format_size = 4;
  // CompileOptionsProto.executable_build_options (field 3), containing
  // ExecutableBuildOptionsProto.num_replicas=1 (4), num_partitions=1 (5).
  // Use the wire format to avoid linking protobuf or XLA C++ libraries.
  const char compile_options[] = "\x1a\x04\x20\x01\x28\x01";
  ARGS(PJRT_Client_Compile_Args, compile);
  compile.client = client.get();
  compile.program = &program;
  compile.compile_options = compile_options;
  compile.compile_options_size = sizeof(compile_options) - 1;
  CALL(PJRT_Client_Compile, compile);
  auto executable = OWN(PJRT_LoadedExecutable, compile.executable);
  require(executable != nullptr, "null executable");
  std::cout << "StableHLO compiled\n";

  ARGS(PJRT_LoadedExecutable_AddressableDevices_Args, placement);
  placement.executable = executable.get();
  CALL(PJRT_LoadedExecutable_AddressableDevices, placement);
  require(placement.num_addressable_devices == 1,
          "expected single-device executable");
  PJRT_Device *device = placement.addressable_devices[0];
  bool addressable = false;
  for (size_t i = 0; i < devices.num_addressable_devices; ++i)
    addressable |= device == devices.addressable_devices[i];
  require(addressable, "executable device is not addressable by this client");
  ARGS(PJRT_Device_GetDescription_Args, description);
  description.device = device;
  CALL(PJRT_Device_GetDescription, description);
  ARGS(PJRT_DeviceDescription_Kind_Args, kind);
  kind.device_description = description.device_description;
  CALL(PJRT_DeviceDescription_Kind, kind);
  std::cout << "Execution device: "
            << std::string(kind.device_kind, kind.device_kind_size) << '\n';

  const std::array<float, 6> x = {1, -2, 3, 0.5, -4, 8};
  const std::array<float, 6> y = {2, 5, -1, 1.5, 3, -2};
  auto input_x = upload(api, client.get(), device, x);
  auto input_y = upload(api, client.get(), device, y);
  std::cout << "Nonconstant inputs transferred\n";
  PJRT_Buffer *inputs[] = {input_x.get(), input_y.get()};
  PJRT_Buffer *const *input_lists[] = {inputs};
  PJRT_Buffer *outputs[] = {nullptr, nullptr};
  PJRT_Buffer **output_lists[] = {outputs};
  PJRT_Event *events[] = {nullptr};
  ARGS(PJRT_ExecuteOptions, options);
  // Inputs remain ours and must not be donated to the executable.
  const int64_t non_donatable[] = {0, 1};
  options.non_donatable_input_indices = non_donatable;
  options.num_non_donatable_input_indices = 2;
  ARGS(PJRT_LoadedExecutable_Execute_Args, execute);
  execute.executable = executable.get();
  execute.options = &options;
  execute.argument_lists = input_lists;
  execute.num_devices = 1;
  execute.num_args = 2;
  execute.output_lists = output_lists;
  execute.device_complete_events = events;
  CALL(PJRT_LoadedExecutable_Execute, execute);
  auto output = OWN(PJRT_Buffer, outputs[0]);
  auto transcendental_output = OWN(PJRT_Buffer, outputs[1]);
  await(api, events[0]);
  require(output != nullptr, "null arithmetic output buffer");
  require(transcendental_output != nullptr,
          "null transcendental output buffer");
  std::cout << "Execution completed\n";

  ARGS(PJRT_Buffer_ElementType_Args, type);
  type.buffer = output.get();
  CALL(PJRT_Buffer_ElementType, type);
  require(type.type == PJRT_Buffer_Type_F32, "output type is not f32");
  ARGS(PJRT_Buffer_Dimensions_Args, shape);
  shape.buffer = output.get();
  CALL(PJRT_Buffer_Dimensions, shape);
  require(shape.num_dims == 2 && shape.dims[0] == 2 && shape.dims[1] == 3,
          "output shape is not [2,3]");
  ARGS(PJRT_Buffer_Device_Args, output_device);
  output_device.buffer = output.get();
  CALL(PJRT_Buffer_Device, output_device);
  require(output_device.device == device, "output is on the wrong device");

  std::array<float, 6> result{};
  ARGS(PJRT_Buffer_ToHostBuffer_Args, download);
  download.src = output.get();
  download.dst = result.data();
  download.dst_size = sizeof(result);
  CALL(PJRT_Buffer_ToHostBuffer, download);
  await(api, download.event);
  std::cout << "Result transferred: f32[2,3]";
  for (float value : result)
    std::cout << ' ' << value;
  std::cout << '\n';
  std::array<float, 6> expected = {3, -6, 6, 1, 4, 48};
  if (wrong_expected)
    expected[0] += 1;
  for (size_t i = 0; i < result.size(); ++i)
    require(
        std::isfinite(result[i]) && std::abs(result[i] - expected[i]) < 1e-5f,
        "value mismatch at element " + std::to_string(i) + ": expected " +
            std::to_string(expected[i]) + ", got " + std::to_string(result[i]));

  ARGS(PJRT_Buffer_ElementType_Args, transcendental_type);
  transcendental_type.buffer = transcendental_output.get();
  CALL(PJRT_Buffer_ElementType, transcendental_type);
  require(transcendental_type.type == PJRT_Buffer_Type_F32,
          "transcendental output type is not f32");
  ARGS(PJRT_Buffer_Dimensions_Args, transcendental_shape);
  transcendental_shape.buffer = transcendental_output.get();
  CALL(PJRT_Buffer_Dimensions, transcendental_shape);
  require(transcendental_shape.num_dims == 2 &&
              transcendental_shape.dims[0] == 2 &&
              transcendental_shape.dims[1] == 3,
          "transcendental output shape is not [2,3]");
  ARGS(PJRT_Buffer_Device_Args, transcendental_device);
  transcendental_device.buffer = transcendental_output.get();
  CALL(PJRT_Buffer_Device, transcendental_device);
  require(transcendental_device.device == device,
          "transcendental output is on the wrong device");

  std::array<float, 6> transcendental_result{};
  ARGS(PJRT_Buffer_ToHostBuffer_Args, transcendental_download);
  transcendental_download.src = transcendental_output.get();
  transcendental_download.dst = transcendental_result.data();
  transcendental_download.dst_size = sizeof(transcendental_result);
  CALL(PJRT_Buffer_ToHostBuffer, transcendental_download);
  await(api, transcendental_download.event);
  std::cout << "Transcendental result transferred: f32[2,3]";
  for (float value : transcendental_result)
    std::cout << ' ' << value;
  std::cout << '\n';
  for (size_t i = 0; i < transcendental_result.size(); ++i) {
    const float transcendental_expected = std::sin(x[i] + y[i]);
    require(std::isfinite(transcendental_result[i]) &&
                std::abs(transcendental_result[i] - transcendental_expected) <
                    1e-5f,
            "transcendental value mismatch at element " + std::to_string(i) +
                ": expected " + std::to_string(transcendental_expected) +
                ", got " + std::to_string(transcendental_result[i]));
  }
}

int main(int argc, char **argv) {
  std::cout << std::unitbuf;
  if ((argc != 3 && argc != 4) ||
      (std::string(argv[2]) != "cpu" && std::string(argv[2]) != "cuda") ||
      (argc == 4 && std::string(argv[3]) != "--wrong-expected")) {
    std::cerr
        << "Usage: pjrt-execute PLUGIN.so {cpu|cuda} [--wrong-expected]\n";
    return 2;
  }
  try {
    run(argv[1], argv[2], argc == 4);
    require(!cleanup_failed, "resource destruction failed");
    std::cout << "PASS: " << argv[2] << " StableHLO compile/execute/readback\n";
    return 0;
  } catch (const std::exception &error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}
