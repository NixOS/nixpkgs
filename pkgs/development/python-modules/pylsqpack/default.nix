{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylsqpack";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RnStwsgzwccKNkVPV3Tp3vlPwxCeSoRk2ASvKiAwlXo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pylsqpack" ];

  meta = {
    description = "Python wrapper for the ls-qpack QPACK library";
    homepage = "https://github.com/aiortc/pylsqpack";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
