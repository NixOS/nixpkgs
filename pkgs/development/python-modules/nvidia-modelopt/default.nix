{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  cudaPackages,
  python,
  symlinkJoin,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  huggingface-hub,
  ninja,
  numpy,
  nvidia-ml-py,
  omegaconf,
  packaging,
  pulp,
  pydantic,
  pyyaml,
  regex,
  requests,
  rich,
  safetensors,
  scipy,
  torch,
  tqdm,

  # optional-dependencies
  accelerate,
  cppimport,
  datasets,
  deepspeed,
  diffusers,
  fire,
  hydra-core,
  immutabledict,
  lief,
  lru-dict,
  ml-dtypes,
  nltk,
  onnx,
  onnx-graphsurgeon,
  onnxconverter-common,
  onnxruntime,
  onnxscript,
  onnxslim,
  pandas,
  peft,
  polygraphy,
  sentencepiece,
  tiktoken,
  transformers,
  typeguard,

  # tests
  pytest-timeout,
  pytestCheckHook,
  timm,
  torchvision,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-modelopt";
  version = "0.47.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "Model-Optimizer";
    tag = finalAttrs.version;
    hash = "sha256-kvvyPPZ8APbN8kvT7fOqX5uxuzA6MTWY/4CEEKbSh8U=";
  };

  # The upper bound only guards against future major releases.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-scm>=8,<10"' '"setuptools-scm>=8"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  # setuptools is a run-time dependency: torch.utils.cpp_extension, used to JIT-compile the CUDA kernels, imports it.
  dependencies = [
    # Imported by modelopt.torch.opt.plugins.huggingface, which modelopt.torch imports unconditionally, but only declared
    # by the hf extra
    huggingface-hub
    ninja
    numpy
    nvidia-ml-py
    omegaconf
    packaging
    pulp
    pydantic
    pyyaml
    regex
    # Imported by modelopt.torch.utils.dataset_utils, but missing from the declared dependencies
    requests
    rich
    safetensors
    scipy
    setuptools
    torch
    tqdm
  ];

  optional-dependencies = {
    # Left out: cupy-cuda12x, an optional GPU accelerator for INT4 ONNX quantization, which falls back to NumPy.
    onnx = [
      cppimport
      lief
      ml-dtypes
      onnx
      onnx-graphsurgeon
      onnxconverter-common
      onnxruntime
      onnxscript
      onnxslim
      polygraphy
    ];
    # Upstream tests against transformers<5.15 (and warns on import with newer versions), but supports any version
    # from 4.57.
    # Left out: wonderwords, used to generate the RULER calibration dataset for sparse attention, isn't packaged.
    hf = [
      accelerate
      datasets
      deepspeed
      diffusers
      nltk
      peft
      sentencepiece
      tiktoken
      transformers
    ];
    puzzletron = [
      fire
      hydra-core
      immutabledict
      lru-dict
      pandas
      typeguard
    ];
  };

  # modelopt.onnx.quantization.extensions builds the INT4 packing extension with cppimport on first use, next to its
  # source, which is read-only in the store (it falls back to NumPy then). Build it here instead. This happens after
  # fixupPhase because cppimport validates the extension by a checksum it appends to the shared object, which stripping
  # would remove.
  nativeBuildInputs = [ cppimport ];

  # Without debug info, which would keep references to the compiler, glibc's headers and pybind11 in the runtime
  # closure, and without the rendered source (cppimport's input to the compiler), which loading doesn't need.
  postFixup = ''
    src_dir="$out/${python.sitePackages}/modelopt/onnx/quantization/src"
    CXXFLAGS=-g0 python -c 'import cppimport, sys; cppimport.build_filepath(sys.argv[1])' \
      "$src_dir/modelopt_round_and_pack_ext.cpp"
    rm "$src_dir/.rendered.modelopt_round_and_pack_ext.cpp"
  ''
  # Check that the extension loads without rebuilding from a read-only directory.
  + ''
    chmod a-w "$src_dir"
    PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH" python -c \
      'import modelopt.onnx.quantization.extensions as ext; assert ext.round_and_pack_ext is not None'
    chmod u+w "$src_dir"
  '';

  pythonImportsCheck = [
    "modelopt"
    "modelopt.torch"
    "modelopt.torch.quantization"
  ];

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
    timm
    torchvision
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.onnx;

  # Drop the coverage and pytest-instafail options.
  pytestFlags = [
    "-oaddopts=--strict-markers"
  ];

  # A subset of the CPU unit tests: quantization, the conversion/save/restore machinery and the ONNX tooling.
  enabledTestPaths = [
    "tests/unit/onnx"
    "tests/unit/torch/opt"
    "tests/unit/torch/quantization"
  ];

  disabledTests = [
    # Float16 outputs differ beyond the tolerance with onnxruntime 1.27 (upstream tests with 1.24)
    "test_column_major_transformation_output_equivalence"
    "test_column_major_gemm_trans_b_flip"

    # Spawns gloo workers, which time out in the sandbox
    "test_data_parallel"
  ];

  disabledTestPaths = [
    # Needs torch-geometric
    "tests/unit/torch/quantization/plugins/test_pytorch_geometric_plugin.py"
  ];

  passthru = lib.optionalAttrs torch.cudaSupport {
    # Quantizes with the CUDA kernels, which torch.utils.cpp_extension JIT-compiles on first use, so torch must be able
    # to find a CUDA toolkit at run time.
    gpuCheck = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
      requiredSystemFeatures = [ "cuda" ];

      # torch.utils.cpp_extension runs `ninja` from PATH; as a dependency, it is only on PYTHONPATH.
      nativeInstallCheckInputs = prevAttrs.nativeInstallCheckInputs ++ [ ninja ];

      # Bound the parallelism of the ninja builds torch.utils.cpp_extension runs.
      preCheck =
        (prevAttrs.preCheck or "")
        + ''
          export MAX_JOBS="$NIX_BUILD_CORES"
        ''
        # The CUDA toolkit torch.utils.cpp_extension compiles with, in the usual layout (`bin/nvcc`, `include`, `lib64`):
        # the kernels include the CUDA runtime's headers and CCCL's (cub, libcu++).
        + ''
          export CUDA_HOME=${
            symlinkJoin {
              name = "nvidia-modelopt-cuda-home";
              paths = lib.concatMap (p: map (o: p.${o}) (lib.remove "static" p.outputs)) (
                lib.filter (p: p != null) (
                  with cudaPackages;
                  [
                    cccl
                    cuda_crt
                    cuda_cudart
                    cuda_nvcc
                  ]
                )
              );
              postBuild = ''
                ln -s lib $out/lib64
              '';
            }
          }
        '';

      enabledTestPaths = [
        # Compiles the tensor_quant, FP8 and MX extensions
        "tests/gpu/_extensions/test_torch_extensions.py"
        # Fake quantization with the compiled tensor_quant extension
        "tests/gpu/torch/quantization/test_tensor_quant_cuda.py"
        "tests/gpu/torch/quantization/test_quantize_cuda.py"
      ];
    });
  };

  meta = {
    description = "Library of model optimization techniques such as quantization, pruning, distillation and speculative decoding";
    homepage = "https://github.com/NVIDIA/Model-Optimizer";
    changelog = "https://github.com/NVIDIA/Model-Optimizer/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
  };
})
