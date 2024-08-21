{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "intelhex";
  version = "2.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iStzYacZ9JRSN9qMz3VOlRPbMvViiFJ4WuoQjc0lAJM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "intelhex/test.py" ];

  pythonImportsCheck = [ "intelhex" ];

  meta = {
    homepage = "https://github.com/bialix/intelhex";
    description = "Python library for Intel HEX files manipulations";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pjones ];
  };
}
