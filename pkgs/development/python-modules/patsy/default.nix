{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  numpy,
  scipy, # optional, allows spline-related features (see patsy's docs)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "patsy";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydata";
    repo = "patsy";
    rev = "refs/tags/v${version}";
    hash = "sha256-gtkvFxNzMFiBBiuKhelSSsTilA/fLJSC5QHqDLiRrWE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "patsy" ];

  meta = {
    changelog = "https://github.com/pydata/patsy/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Python package for describing statistical models";
    homepage = "https://github.com/pydata/patsy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}
