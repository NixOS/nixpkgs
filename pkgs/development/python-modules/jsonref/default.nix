{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock }:

buildPythonPackage rec {
  pname = "jsonref";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3c45b121cf6257eafabdc3a8008763aed1cd7da06dbabc59a9e4d2a5e4e6697";
  };

  buildInputs = [ pytest mock ];

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
