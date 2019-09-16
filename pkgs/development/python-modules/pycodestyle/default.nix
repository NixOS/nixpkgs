{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e40a936c9a450ad81df37f549d676d127b1b66000a6c500caa2b085bc0ca976c";
  };

  meta = with lib; {
    description = "Python style guide checker (formerly called pep8)";
    homepage = https://pycodestyle.readthedocs.io;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
