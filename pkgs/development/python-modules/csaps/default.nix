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
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espdev";
    repo = "csaps";
    tag = "v${version}";
    hash = "sha256-1pNJaNExhcRWDjJenEKp1eJ4wZMFXxwWcmepEt6/p0s=";
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
