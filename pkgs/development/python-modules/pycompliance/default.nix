{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycompliance";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhmdnd";
    repo = "pycompliance";
    rev = version;
    hash = "sha256-gCrKbKqRDlh9q9bETQ9NEPbf+40WKF1ltfBy6LYjlVw=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pycompliance" ];

  meta = {
    description = "Simply library to represent compliance benchmarks as tree structures";
    homepage = "https://github.com/rhmdnd/pycompliance";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tochiaha ];
  };
}
