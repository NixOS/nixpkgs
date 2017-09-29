{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock }:

buildPythonPackage rec {
  pname = "jsonref";
  version = "0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lqa8dy1sr1bxi00ri79lmbxvzxi84ki8p46zynyrgcqhwicxq2n";
  };

  buildInputs = [ pytest mock ];

  checkPhase = ''
    py.test tests.py
  '';

  meta = with stdenv.lib; {
    description = "An implementation of JSON Reference for Python";
    homepage    = "http://github.com/gazpachoking/jsonref";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
