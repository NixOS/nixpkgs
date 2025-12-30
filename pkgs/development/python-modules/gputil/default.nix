{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  distutils,
}:

buildPythonPackage rec {
  pname = "gputil";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anderskm";
    repo = "gputil";
    tag = "v${version}";
    hash = "sha256-iOyB653BMmDBtK1fM1ZyddjlnaypsuLMOV0sKaBt+yE=";
  };

  build-system = [ setuptools ];

  dependencies = [ distutils ];

  pythonImportsCheck = [ "GPUtil" ];

  meta = {
    homepage = "https://github.com/anderskm/gputil";
    license = lib.licenses.mit;
    description = "Getting GPU status from NVIDA GPUs using nvidia-smi";
    changelog = "https://github.com/anderskm/gputil/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [
      doronbehar
    ];
  };
}
