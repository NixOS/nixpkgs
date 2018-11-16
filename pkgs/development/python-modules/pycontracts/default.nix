{ stdenv, buildPythonPackage, fetchPypi
, nose, pyparsing, decorator, six, future }:

buildPythonPackage rec {
  pname = "PyContracts";
  version = "1.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b6ad8750bbb712b1c7b8f89772b42baeefd35b3c7085233e8027b92f277e073";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pyparsing decorator six future ];

  meta = with stdenv.lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = https://pypi.python.org/pypi/PyContracts;
    license = licenses.lgpl2;
  };
}
