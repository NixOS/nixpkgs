{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  datasets,
  fastapi,
  mlx,
  mlx-lm,
  numpy,
  opencv-python,
  pillow,
  requests,
  soundfile,
  tqdm,
  transformers,
  uvicorn,

  # tests
  psutil,
  pytestCheckHook,
  rich,
}:

buildPythonPackage rec {
  pname = "mlx-vlm";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Blaizzy";
    repo = "mlx-vlm";
    tag = "v${version}";
    hash = "sha256-L+llrfFo4C++JZ3GjpZi16wMZNXtKrYh3pxhZ5N1n/4=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "opencv-python"
  ];
  dependencies = [
    datasets
    fastapi
    mlx
    mlx-lm
    numpy
    opencv-python
    pillow
    requests
    soundfile
    tqdm
    transformers
    uvicorn
  ];

  pythonImportsCheck = [ "mlx_vlm" ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    rich
  ];

  disabledTests = [
    # Fatal Python error: Aborted
    # mlx_vlm/models/multi_modality/vision.py", line 174 in __call__
    "test_multi_modality"

    # RuntimeError: [metal_kernel] No GPU back-end
    "test_glm4v"
    "test_glm4v_moe"
    "test_kimi_vl"
  ];

  disabledTestPaths = [
    # ImportError: cannot import name 'get_class_predicate' from 'mlx_vlm.utils'
    # This function is indeed not exposed by `mlx_vlm.utils`
    "mlx_vlm/tests/test_utils.py"

    # fixture 'model_path' not found
    "mlx_vlm/tests/test_smoke.py"
  ];

  meta = {
    description = "Inference and fine-tuning of Vision Language Models (VLMs) on your Mac using MLX";
    homepage = "https://github.com/Blaizzy/mlx-vlm";
    changelog = "https://github.com/Blaizzy/mlx-vlm/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = [
      "aarch64-darwin"
    ];
  };
}
