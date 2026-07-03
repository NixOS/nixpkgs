{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "dbglib";
  version = "0.3.0";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    sha256 = "7b4fd5c4949af435a7ab558f87b406acd5ddf9dc7f01fc3b3e99ebcec9a4674c";
  };
  propagatedBuildInputs = [ poetry-core ];
  pythonImportsCheck = [ "dbglib" ];
  meta = {
    homepage = "https://github.com/savioxavier/dbglib/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jetpackjackson ];
  };
}
