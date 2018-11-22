{ stdenv, buildPythonPackage, fetchPypi
, nose, pyparsing, decorator, six, future }:

buildPythonPackage rec {
  pname = "PyContracts";
  version = "1.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b65jkbk9bcl10s49w9frsjcarfzi8gp22a40cz7zxry8b8yvcf0";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pyparsing decorator six future ];

  meta = with stdenv.lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = https://pypi.python.org/pypi/PyContracts;
    license = licenses.lgpl2;
  };
}
