{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  poetry-core,
  setuptools,

  typing-extensions,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "csaps";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espdev";
    repo = "csaps";
    tag = "v${version}";
    hash = "sha256-T1B0ta104UKLCUc97RQrvUSFt8ZCn9Y1Qiqo4DKHDsI=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    typing-extensions
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "csaps" ];

  meta = {
    description = "Cubic spline approximation (smoothing)";
    homepage = "https://github.com/espdev/csaps";
    changelog = "https://github.com/espdev/csaps/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
