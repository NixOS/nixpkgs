{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  datasets,
  fastapi,
  gradio,
  mlx,
  mlx-lm,
  numpy,
  opencv-python,
  pillow,
  requests,
  tqdm,
  transformers,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mlx-vlm";
  version = "0.1.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Blaizzy";
    repo = "mlx-vlm";
    tag = "v${version}";
    hash = "sha256-USDRLu9PhyYuOyiNqYWk2Wlk9/PUDd/gPjSUzEkjeGc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    datasets
    fastapi
    gradio
    mlx
    mlx-lm
    numpy
    opencv-python
    pillow
    requests
    tqdm
    transformers
  ];

  pythonImportsCheck = [ "mlx_vlm" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Inference and fine-tuning of Vision Language Models (VLMs) on your Mac using MLX";
    homepage = "https://github.com/Blaizzy/mlx-vlm";
    changelog = "https://github.com/Blaizzy/mlx-vlm/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
