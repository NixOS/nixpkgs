{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylsqpack";
  version = "0.3.20";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4tgSjvH0VcGYzo6tnXD4rKklM6bqUTSB8eXrVGoruDQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsqpack" ];

  meta = with lib; {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
