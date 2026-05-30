{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "dicttoxml2";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z8tynzN911KAjAIbcMjfijT4S54RGl26o34ADur01GI=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "dicttoxml2" ];

  meta = {
    description = "Converts a Python dictionary or other native data type into a valid XML string";
    homepage = "https://pypi.org/project/dicttoxml2/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
