{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  nix-update-script,
  python,

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
  httpx,
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
  torch-geometric,
  torchvision,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-modelopt";
  version = "0.48.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "Model-Optimizer";
    tag = finalAttrs.version;
    hash = "sha256-yxG+FMxA0RS7BdaCclzQ/DyNBMXoAB9R1pKZpyrRXUc=";
  };

  patches = [
    # Allow setuptools-scm 10, which Nixpkgs has, as a build requirement again
    # https://github.com/NVIDIA/Model-Optimizer/pull/3022
    (fetchpatch2 {
      name = "allow-setuptools-scm-10.patch";
      url = "https://github.com/NVIDIA/Model-Optimizer/commit/607263d4b00b48eba2972e94af8b67666a67048a.patch?full_index=1";
      hash = "sha256-ezf36wbLjg4CLrsU9Tj18CNNCMB3uWYwiMJvkmX6Ruw=";
    })
  ];

  # Don't apply upstream's per-test wall-clock timeouts (60s for unit tests): the ONNX tests that run a large Conv
  # (test_conv_isinf_*) exceed them on busy builders.
  postPatch = ''
    substituteInPlace tests/conftest.py \
      --replace-fail \
        "item.add_marker(pytest.mark.timeout(_DEFAULT_TIMEOUT[group]))" \
        "pass"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  # setuptools is a run-time dependency: torch.utils.cpp_extension, used to JIT-compile the CUDA kernels, imports it.
  dependencies = [
    ninja
    numpy
    nvidia-ml-py
    omegaconf
    packaging
    pulp
    pydantic
    pyyaml
    regex
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
    # 0.48.0 is tested with transformers 5.5 to 5.18 and warns on import with newer ones.
    # Left out: wonderwords, used to generate the RULER calibration dataset for sparse attention, isn't packaged.
    hf = [
      accelerate
      datasets
      deepspeed
      diffusers
      httpx
      huggingface-hub
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
  '';

  # Check that the extension in $out loads from a read-only directory without a rebuild. `-P` keeps the source tree in
  # the working directory off sys.path. Importing modelopt.onnx needs the onnx extra, which only the check inputs have.
  postInstallCheck = ''
    src_dir="$out/${python.sitePackages}/modelopt/onnx/quantization/src"
    chmod a-w "$src_dir"
    PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH" python -P -c \
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
    torch-geometric
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
    # Imports modelopt.torch without the hf extra's modules (and requests)
    "tests/unit/torch/test_import.py"
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    # (torch queries it to cast to float16 on the CPU, which the GGML formats do for their scales.)
    # This one also fails outside the sandbox on aarch64 (an NVIDIA GB10): oneDNN can't create a float16 convolution
    "tests/unit/torch/opt/test_chaining.py::test_chained_modes_preserve_forward_patching_during_quantize"
    "tests/unit/torch/quantization/test_forward_patching.py::test_quantize_calibration_calls_quantizers_with_runtime_forward_patch"
    "tests/unit/torch/quantization/test_ggml_backend.py"
    "tests/unit/torch/quantization/test_ggml_gptq.py"
    "tests/unit/torch/quantization/test_int8_tensor.py::test_int8_compress_keeps_small_fp16_channel"
    "tests/unit/torch/quantization/test_int8_tensor.py::test_int8_quantize_matches_fp32[layout0-weight0-dtype0]"
    "tests/unit/torch/quantization/test_int8_tensor.py::test_int8_quantize_matches_fp32[layout1-weight1-dtype0]"
    "tests/unit/torch/quantization/test_int8_tensor.py::test_int8_quantize_matches_fp32[layout2-weight2-dtype0]"
    "tests/unit/torch/quantization/test_iq1_s.py"
    "tests/unit/torch/quantization/test_iq2_xs.py"
    "tests/unit/torch/quantization/test_iq_formats.py"
    "tests/unit/torch/quantization/test_lsq.py::TestEnableLSQ::test_learnable_amax_uses_input_dtype[dtype0]"
    "tests/unit/torch/quantization/test_lsq.py::TestLSQWeightIteration::test_multiple_singular_weight_quantizers_use_their_weight_dtypes"
    "tests/unit/torch/quantization/test_q8_0.py"
    "tests/unit/torch/quantization/test_tensor_quant_cpu.py::TestFakeTensorQuantCPU::test_overflow_fp16"
    "tests/unit/torch/quantization/test_tensor_quant_cpu.py::test_registered_cpu_quantize_matches_eager[block-dtype1]"
    "tests/unit/torch/quantization/test_tensor_quant_cpu.py::test_registered_cpu_quantize_matches_eager[per_axis-dtype1]"
    "tests/unit/torch/quantization/test_tensor_quant_cpu.py::test_registered_cpu_quantize_matches_eager[scalar-dtype1]"
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    # nix-update's default source, the releases feed, also lists upstream's development tags (such as 0.48.0dev) as
    # stable versions. GitHub's release list leaves them out and marks the release candidates as prereleases.
    updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };
  }
  // lib.optionalAttrs torch.cudaSupport {
    # Quantizes with the CUDA kernels, which torch.utils.cpp_extension JIT-compiles on first use.
    gpuCheck = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
      requiredSystemFeatures = [ "cuda" ];

      # buildPythonPackage renames the check inputs (nativeCheckInputs to nativeInstallCheckInputs, checkInputs to
      # installCheckInputs), and overrideAttrs sees the renamed attributes. The CUDA packages are torch's, so the kernels
      # build with the CUDA release torch uses.
      # torch.utils.cpp_extension runs `ninja` from PATH (as a dependency, it is only on PYTHONPATH) and takes the prefix
      # of the `nvcc` on PATH as its CUDA home.
      nativeInstallCheckInputs = prevAttrs.nativeInstallCheckInputs ++ [
        torch.cudaPackages.cuda_nvcc
        ninja
      ];

      # The kernels include the CUDA runtime's headers and link against it. It propagates CCCL's headers and, from CUDA
      # 13.0, the CRT's.
      installCheckInputs = prevAttrs.installCheckInputs ++ [ torch.cudaPackages.cuda_cudart ];

      # Bound the parallelism of the ninja builds torch.utils.cpp_extension runs.
      preCheck = (prevAttrs.preCheck or "") + ''
        export MAX_JOBS="$NIX_BUILD_CORES"
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
