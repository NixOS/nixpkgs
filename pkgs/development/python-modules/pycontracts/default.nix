{ stdenv, buildPythonPackage, fetchPypi
, nose, pyparsing, decorator, six, future }:

buildPythonPackage rec {
  pname = "PyContracts";
  version = "1.8.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e76adbd832deec28b2045a6094c5bb779a0b2cb1105a23b3efafe723e2c9937a";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pyparsing decorator six future ];

  meta = with stdenv.lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = https://pypi.python.org/pypi/PyContracts;
    license = licenses.lgpl2;
  };
}
