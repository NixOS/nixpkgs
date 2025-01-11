{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  numpy,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "pyfma";
    rev = version;
    hash = "sha256-1qNa+FcIAP1IMzdNKrEbTVPo6gTOSCvhTRIHm6REJoo=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pybind11 ];

  dependencies = [ numpy ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfma" ];

  meta = with lib; {
    description = "Fused multiply-add for Python";
    homepage = "https://github.com/nschloe/pyfma";
    changelog = "https://github.com/nschloe/pyfma/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
