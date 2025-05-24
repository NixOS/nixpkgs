{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  mlx,
  numpy,
  protobuf,
  pyyaml,
  transformers,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mlx-lm";
  version = "0.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx-lm";
    tag = "v${version}";
    hash = "sha256-d//JUhvRpNde1+drWWYJ9lmkXi+buaa1zxDg4rQdt0o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    jinja2
    mlx
    numpy
    protobuf
    pyyaml
    transformers
  ];

  pythonImportsCheck = [ "mlx_lm" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Run LLMs with MLX";
    homepage = "https://github.com/ml-explore/mlx-lm";
    changelog = "https://github.com/ml-explore/mlx-lm/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
