{ stdenv, buildPythonPackage, fetchPypi
, nose, pyparsing, decorator, six, future }:

buildPythonPackage rec {
  pname = "PyContracts";
  version = "1.8.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0njcssvjj2aisb52xp9jmfps43iqg3fw4grj524i911p34yln2va";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pyparsing decorator six future ];

  meta = with stdenv.lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = https://pypi.python.org/pypi/PyContracts;
    license = licenses.lgpl2;
  };
}
