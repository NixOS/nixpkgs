{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock }:

buildPythonPackage rec {
  pname = "jsonref";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15v69rg2lkcykb2spnq6vbbirv9sfq480fnwmfppw9gn3h95pi7k";
  };

  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test tests.py
  '';

  meta = with stdenv.lib; {
    description = "An implementation of JSON Reference for Python";
    homepage    = "https://github.com/gazpachoking/jsonref";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
