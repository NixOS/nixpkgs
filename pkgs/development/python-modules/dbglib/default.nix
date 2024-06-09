{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dbglib";
  version = "0.3.0";
  format = "pyproject";
  disabled = pythonOlder "3.9";
  src = fetchPypi {
    inherit pname version;
    sha256 = "7b4fd5c4949af435a7ab558f87b406acd5ddf9dc7f01fc3b3e99ebcec9a4674c";
  };
  propagatedBuildInputs = [ poetry-core ];
  pythonImportsCheck = [ "dbglib" ];
  meta = with lib; {
    homepage = "https://github.com/savioxavier/dbglib/";
    license = licenses.mit;
    maintainers = [ maintainers.jetpackjackson ];
  };
}
