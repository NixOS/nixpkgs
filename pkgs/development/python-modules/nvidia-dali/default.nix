{
  lib,
  buildPythonPackage,
  cudaPackages,
  python,

  # buildInputs
  pybind11,

  # build-system
  setuptools,

  # dependencies
  astunparse,
  gast,
  libcst,
  makefun,
  numpy,
  nvtx,
  optree,
  packaging,
  six,
}:

let
  inherit (cudaPackages) dali;
  inherit (lib) cmakeBool cmakeFeature;
in
buildPythonPackage (finalAttrs: {
  pname = "nvidia-dali";
  inherit (dali) version src patches;
  pyproject = true;
  __structuredAttrs = true;

  postPatch =
    # Replaces the submodules of the header-only libraries with Nixpkgs', as for the C++ libraries.
    dali.postPatch
    # Name the distribution nvidia-dali instead of nvidia-dali-cuda<CUDA major>0, since Nixpkgs selects the CUDA version
    # with cudaPackages, and drop the requirements on the nvImageCodec and nvCOMP wheels: DALI loads both with dlopen,
    # and cudaPackages.dali has them in its runpath.
    + ''
      substituteInPlace dali/python/setup.py.in \
        --replace-fail \
          "name='nvidia-dali@DALI_FLAVOR_MINUS@-cuda@CUDA_VERSION_SHORT_DIGIT_ONLY@'" \
          "name='nvidia-dali'" \
        --replace-fail "@DALI_INSTALL_REQUIRES_NVIMGCODEC@" "" \
        --replace-fail "@DALI_INSTALL_REQUIRES_NVCOMP@" ""
    '';

  # The bindings are built with the configuration of the C++ libraries, which CMake checks again.
  inherit (dali) nativeBuildInputs;

  buildInputs = dali.buildInputs ++ [
    dali
    pybind11
  ];

  build-system = [ setuptools ];

  dependencies = [
    astunparse
    gast
    libcst
    makefun
    numpy
    nvtx
    optree
    packaging
    six
  ];

  # Build only the Python bindings (backend_impl and the python_function plugin), against the C++ libraries of
  # cudaPackages.dali, like conda-forge does. The flags of the C++ libraries set BUILD_PYTHON=OFF; the later value wins.
  cmakeFlags = dali.cmakeFlags ++ [
    (cmakeBool "BUILD_PYTHON" true)
    (cmakeBool "PREBUILD_DALI_LIBS" true)
    (cmakeFeature "PYTHON_VERSIONS" python.pythonVersion)
    (cmakeBool "USE_PREBUILD_PYBIND11" true)
  ];

  # The Python package (with the headers for building plugins) is staged in dali/python of the build tree.
  preBuild = ''
    cmake --build . --target dali_python python_function_plugin copy_post_build_target install_headers
    cd dali/python
  '';

  # nvidia.dali.sysconfig points plugin builds (-L, -ldali) at the package directory, where the wheels bundle the C++
  # libraries.
  postInstall = ''
    ln -s ${lib.getLib dali}/lib/libdali*.so "$out/${python.sitePackages}/nvidia/dali/"
  '';

  pythonImportsCheck = [
    "nvidia.dali"
    # The experimental dynamic mode, the only user of nvtx
    "nvidia.dali.experimental.dynamic"
  ];

  passthru = {
    # Decodes JPEGs on the GPU with nvImageCodec, resizes and median-blurs them (CV-CUDA), and inflates LZ4 data with
    # nvCOMP, which DALI all loads with dlopen.
    gpuCheck =
      ((cudaPackages.writeGpuTestPython.override { python3Packages = python.pkgs; })
        {
          name = "nvidia-dali-gpu-check";
          libraries = ps: [
            ps.lz4
            ps.nvidia-dali
          ];
        }
        ''
          import lz4.block
          import numpy as np
          from nvidia.dali import fn, pipeline_def, types

          images = "${finalAttrs.src}/docs/examples/data/images"


          @pipeline_def(batch_size=4, num_threads=2, device_id=0)
          def decode():
              jpegs, _ = fn.readers.file(file_root=images)
              decoded = fn.decoders.image(jpegs, device="mixed", output_type=types.RGB)
              resized = fn.resize(decoded, resize_x=224, resize_y=224)
              return fn.experimental.median_blur(resized, window_size=3), fn.decoders.image(jpegs, device="cpu")


          pipe = decode()
          gpu, cpu = pipe.run()
          for sample in gpu.as_cpu():
              assert np.array(sample).shape == (224, 224, 3), np.array(sample).shape
          for sample in cpu:
              assert np.array(sample).ndim == 3
          print("decoded, resized and blurred", len(gpu), "images")

          frames = np.arange(85, dtype=np.int32).reshape(17, 5)
          chunks = [np.frombuffer(lz4.block.compress(f.tobytes(), store_size=False), np.uint8) for f in frames]
          sizes = np.array([len(c) for c in chunks], dtype=np.int32)
          # An odd offset, which nvCOMP 6 requires DALI to stage in aligned buffers
          offsets = np.array(1 + np.cumsum([0, *sizes[:-1]]), dtype=np.int32)
          compressed = np.concatenate([np.zeros(1, np.uint8), *chunks])


          @pipeline_def(batch_size=1, num_threads=2, device_id=0)
          def inflate():
              data = fn.external_source(source=lambda: compressed, batch=False)
              return fn.decoders.inflate(
                  data.gpu(), shape=[5], dtype=types.INT32, chunk_offsets=offsets, chunk_sizes=sizes
              )


          (inflated,) = inflate().run()
          np.testing.assert_array_equal(np.array(inflated.as_cpu()[0]), frames)
          print("inflated", len(chunks), "LZ4 chunks")
        ''
      ).gpuCheck;

    # The version and source are cudaPackages.dali's: its update script, run on that attribute, updates both.
    updateScript = dali.updateScript // {
      attrPath = "cudaPackages.dali";
    };
  };

  meta = {
    description = "GPU-accelerated library for data loading and pre-processing for deep learning (Python API)";
    homepage = "https://github.com/NVIDIA/DALI";
    changelog = "https://github.com/NVIDIA/DALI/releases/tag/${finalAttrs.src.tag}";
    inherit (dali.meta) license platforms;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
  };
})
