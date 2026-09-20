{
  addDriverRunpath,
  cuda_cudart,
  cuda_nvml_dev,
  cuda_nvprof,
  cuda_nvrtc,
  cuda_opencl,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  cudaAtLeast,
  lib,
  libcublas,
  libcufft,
  libcufile,
  libcuobjclient,
  libcurand,
  libcusolver,
  libcusparse,
  libnpp,
  libnvfatbin,
  libnvjpeg,
  libnvjitlink,
  nccl,
  patchelf,
  pkg-config,
  stdenv,
  stdenvNoCC,
}:
let
  specifications = {
    cudart = {
      package = cuda_cudart;
      headers = [
        "cuda_runtime.h"
        "cuda/std/type_traits"
      ];
      body = ''
        static_assert(cuda::std::is_integral_v<int>);
        int version;
        return cudaRuntimeGetVersion(&version);
      '';
    };
    cuda = {
      package = cuda_cudart;
      driverRunpath = true;
      headers = [ "cuda.h" ];
      body = "int version; return cuDriverGetVersion(&version);";
    };
    nvidia-ml = {
      package = cuda_nvml_dev;
      driverRunpath = true;
      headers = [ "nvml.h" ];
      body = "return nvmlInit_v2();";
    };
    nvidia-ml-mapped-stubs = specifications.nvidia-ml // {
      module = "nvidia-ml";
      package = cuda_nvml_dev.overrideAttrs (old: {
        outputs = [
          "out"
          "dev"
          "include"
          "samples"
        ];
        outputStubs = "samples";
        passthru = old.passthru // {
          outputToPatterns = old.passthru.outputToPatterns // {
            samples = [ "lib/stubs" ];
          };
        };
      });
    };
    nvrtc = {
      package = cuda_nvrtc;
      headers = [ "nvrtc.h" ];
      body = "int major, minor; return nvrtcVersion(&major, &minor);";
    };
    nvjitlink = {
      package = libnvjitlink;
      headers = [ "nvJitLink.h" ];
      body = "unsigned major, minor; return nvJitLinkVersion(&major, &minor);";
    };
    nvfatbin = {
      package = libnvfatbin;
      headers = [ "nvFatbin.h" ];
      symbol = "nvFatbinVersion";
    };
    nvjpeg = {
      package = libnvjpeg;
      cudaHeaders = true;
      headers = [ "nvjpeg.h" ];
      symbol = "nvjpegGetProperty";
    };
    cublas = {
      package = libcublas;
      cudaHeaders = true;
      headers = [ "cublas_v2.h" ];
      # The legacy and v2 interfaces are alternative translation-unit APIs.
      extraHeaders = [
        "cublas.h"
        "cublasLt.h"
        "cublasXt.h"
      ];
      body = "cublasHandle_t handle; return cublasCreate(&handle);";
    };
    cufft = {
      package = libcufft;
      cudaHeaders = true;
      headers = [ "cufftXt.h" ];
      body = "int version; return cufftGetVersion(&version);";
    };
    cufftw = {
      package = libcufft;
      cudaHeaders = true;
      headers = [ "cufftw.h" ];
      body = "fftw_cleanup(); return 0;";
    };
    cufile = {
      package = libcufile;
      cudaHeaders = true;
      requiredModule = "cuda";
      headers = [ "cufile.h" ];
      body = "return cuFileDriverOpen().err;";
    };
    curand = {
      package = libcurand;
      cudaHeaders = true;
      headers = [ "curand.h" ];
      body = "int version; return curandGetVersion(&version);";
    };
    cusolver = {
      package = libcusolver;
      cudaHeaders = true;
      headers = [
        "cusolverDn.h"
        "cusolverSp.h"
        "cusolverRf.h"
      ];
      body = ''
        cusolverDnHandle_t dense;
        cusolverSpHandle_t sparse;
        cusolverRfHandle_t refactor;
        return cusolverDnCreate(&dense) + cusolverSpCreate(&sparse) + cusolverRfCreate(&refactor);
      '';
    };
    cusparse = {
      package = libcusparse;
      cudaHeaders = true;
      headers = [ "cusparse.h" ];
      body = "cusparseHandle_t handle; return cusparseCreate(&handle);";
    };
    nccl = {
      package = nccl;
      cudaHeaders = true;
      headers = [ "nccl.h" ];
      body = "int version; return ncclGetVersion(&version);";
    };
  }
  //
    lib.mapAttrs
      (module: entry: {
        package = libnpp;
        cudaHeaders = true;
        headers = [ entry.header ];
        inherit (entry) symbol;
        # These obsolete upstream files name libraries absent from the archive.
        absentModules = lib.optionals (module == "nppc") [
          "nppi"
          "nppicom"
          "nppi-${cudaMajorMinorVersion}"
          "nppicom-${cudaMajorMinorVersion}"
        ];
      })
      {
        nppc = {
          header = "nppcore.h";
          symbol = "nppGetLibVersion";
        };
        nppial = {
          header = "nppi_arithmetic_and_logical_operations.h";
          symbol = "nppiAdd_8u_C1RSfs_Ctx";
        };
        nppicc = {
          header = "nppi_color_conversion.h";
          symbol = "nppiRGBToGray_8u_C3C1R_Ctx";
        };
        nppidei = {
          header = "nppi_data_exchange_and_initialization.h";
          symbol = "nppiCopy_8u_C1R_Ctx";
        };
        nppif = {
          header = "nppi_filtering_functions.h";
          symbol = "nppiFilter_8u_C1R_Ctx";
        };
        nppig = {
          header = "nppi_geometry_transforms.h";
          symbol = "nppiResize_8u_C1R_Ctx";
        };
        nppim = {
          header = "nppi_morphological_operations.h";
          symbol = "nppiErode3x3_8u_C1R_Ctx";
        };
        nppist = {
          header = "nppi_statistics_functions.h";
          symbol = "nppiMean_8u_C1R_Ctx";
        };
        nppisu = {
          header = "nppi_support_functions.h";
          symbol = "nppiFree";
        };
        nppitc = {
          header = "nppi_threshold_and_compare_operations.h";
          symbol = "nppiThreshold_8u_C1R_Ctx";
        };
        npps = {
          header = "npps_arithmetic_and_logical_operations.h";
          symbol = "nppsAdd_32f_Ctx";
        };
      }
  // lib.optionalAttrs cuda_opencl.meta.available {
    opencl = {
      package = cuda_opencl;
      headers = [ "CL/cl.h" ];
      symbol = "clGetPlatformIDs";
    };
  }
  // lib.optionalAttrs libcuobjclient.meta.available {
    cuobjclient = {
      package = libcuobjclient;
      cudaHeaders = true;
      requiredModule = "cuda";
      headers = [ "cuobjclient.h" ] ++ lib.optional (cudaAtLeast "13.4") "cuobjextrc_types.h";
      symbol = "cuObjClient::getCtx";
    };
  }
  // lib.optionalAttrs cuda_nvprof.meta.available (
    lib.genAttrs [ "accinj64" "cuinj64" ] (_: {
      package = cuda_nvprof;
      # These are private profiler injection libraries with no public headers.
      # Retain an actual DT_NEEDED entry instead of inventing an API prototype.
      headers = [ ];
      body = "return 0;";
      forceLink = true;
    })
  );
  consumers = lib.mapAttrs (
    name: specification:
    let
      module = specification.module or name;
    in
    stdenv.mkDerivation {
      name = "${cudaNamePrefix}-tests-pkg-config-${name}";
      strictDeps = true;
      dontUnpack = true;
      nativeBuildInputs = [
        pkg-config
      ]
      ++ lib.optional (
        (specification.driverRunpath or false) || (specification.forceLink or false)
      ) patchelf;
      # Each module is isolated: discovery of its public dependencies must come
      # from that package's propagation, not another test case's buildInputs.
      buildInputs = [ specification.package ];
      buildPhase = ''
        runHook preBuild
        cat > consumer.cpp <<'CPP'
        ${lib.concatMapStringsSep "\n" (header: "#include <${header}>") specification.headers}
        ${lib.optionalString (specification ? symbol) ''
          auto * volatile interfaceSymbol = &${specification.symbol};
        ''}
        int main() {
          ${specification.body or "return interfaceSymbol == nullptr;"}
        }
        CPP
        for role in "" _FOR_BUILD _FOR_HOST _FOR_TARGET; do
          unset "NIX_CFLAGS_COMPILE$role" "NIX_LDFLAGS$role"
        done
        unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH

        # Reject discovery of a different role/release's identically named pc.
        pcDir="$($PKG_CONFIG --variable=pcfiledir ${module})"
        case "$pcDir" in
          ${lib.getDev specification.package}/lib/pkgconfig|${lib.getDev specification.package}/share/pkgconfig) ;;
          *) echo "Unexpected ${module} module: $pcDir" >&2; exit 1 ;;
        esac
        ${lib.optionalString (specification.cudaHeaders or false) ''
          test "$($PKG_CONFIG --variable=pcfiledir ${
            specification.requiredModule or "cudart"
          }-${cudaMajorMinorVersion})" = \
            '${lib.getDev cuda_cudart}/share/pkgconfig'
        ''}

        ${lib.concatMapStringsSep "\n" (module: ''
          if "$PKG_CONFIG" --exists ${lib.escapeShellArg module}; then
            echo "Obsolete module still advertised: ${module}" >&2
            exit 1
          fi
        '') (specification.absentModules or [ ])}

        for mode in shared private; do
          options=()
          if [[ $mode == private ]]; then options+=(--static); fi
          read -r -a flags <<< "$($PKG_CONFIG "''${options[@]}" --cflags --libs ${module})"
          printf '%s\n' "''${flags[@]}" > "$mode.flags"
          ${lib.optionalString (specification.cudaHeaders or false) ''
            case " ''${flags[*]} " in
              *" -I${lib.getOutput cuda_cudart.outputInclude cuda_cudart}/include "*) ;;
              *) echo "Missing selected CUDA ${cudaMajorMinorVersion} headers" >&2; exit 1 ;;
            esac
          ''}
          ${
            lib.optionalString (specification.driverRunpath or false) "NIX_ENFORCE_PURITY=0 "
          }"$CXX" -std=c++17 consumer.cpp ${
            lib.optionalString (specification.forceLink or false) "-Wl,--no-as-needed "
          }"''${flags[@]}" -o "consumer-$mode"
          ${
            lib.concatMapStringsSep "\n" (header: ''
              printf '#include <${header}>\n' > header.cpp
              "$CXX" -std=c++17 -fsyntax-only header.cpp "''${flags[@]}"
            '') (specification.extraHeaders or [ ])
          }${
            lib.optionalString (specification.driverRunpath or false) ''
              # Model the installed metadata outside stdenv: the invocation above
              # retains its intentional /run driver path, which build purity would
              # remove. Check before fixup removes the automatically added stub path.
              IFS=: read -r -a runpaths <<< "$(patchelf --print-rpath "consumer-$mode")"
              driverSeen=false
              for path in "''${runpaths[@]}"; do
                case "$path" in
                  ${lib.escapeShellArg "${addDriverRunpath.driverLink}/lib"}) driverSeen=true ;;
                  */lib/stubs)
                    if ! "$driverSeen"; then
                      echo "Driver stub precedes the real driver in RUNPATH" >&2
                      exit 1
                    fi
                    ;;
                esac
              done
              "$driverSeen" || { echo "Missing driver RUNPATH" >&2; exit 1; }
            ''
          }${
            lib.optionalString (specification.forceLink or false) ''
              soname="$(patchelf --print-soname '${lib.getLib specification.package}/lib/lib${module}.so')"
              test -n "$soname" || soname='lib${module}.so'
              patchelf --print-needed "consumer-$mode" | grep --fixed-strings --line-regexp "$soname"
              for flag in "''${flags[@]}"; do
                if [[ $flag == -I* ]]; then test -d "''${flag#-I}"; fi
              done
            ''
          }
        done
        runHook postBuild
      '';
      # --static tests private dependency metadata. NVIDIA's *_static.a
      # archives need explicit selection; these are shared-library consumers.
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/bin" "$out/share"
        cp consumer-shared consumer-private "$out/bin/"
        cp consumer.cpp shared.flags private.flags "$out/share/"
        runHook postInstall
      '';
    }
  ) specifications;
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-pkg-config";
  dontUnpack = true;
  passthru.tests = consumers;
  buildCommand = ''
    mkdir -p "$out"
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: consumer: ''ln -s ${consumer} "$out/${name}"'') consumers
    )}
  '';
}
