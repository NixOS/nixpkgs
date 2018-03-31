{ stdenv, buildPythonPackage, fetchPypi
, nose, pyparsing, decorator, six }:

buildPythonPackage rec {
  pname = "PyContracts";
  version = "1.7.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rdc9pz08885vqkazjc3lyrrghmf3jzxnlsgpn8akl808x1qrfqf";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pyparsing decorator six ];

  meta = with stdenv.lib; {
    description = "Allows to declare constraints on function parameters and return values";
    homepage = https://pypi.python.org/pypi/PyContracts;
    license = licenses.lgpl2;
  };
}
