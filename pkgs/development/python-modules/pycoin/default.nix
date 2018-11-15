{ stdenv, fetchPypi, buildPythonPackage, tox, pytest }:

buildPythonPackage rec {
  pname = "pycoin";
  version = "0.80";

  src = fetchPypi{
    inherit pname version;
    sha256 = "a79a7771c3f6ca2e35667e80983987f0c799c5db01e58016c22a12e8484b2034";
  };

  checkInputs = [ tox pytest ];

  checkPhase = "tox";

  meta = with stdenv.lib; {
    description = "Utilities for Bitcoin and altcoin addresses and transaction manipulation";
    homepage = https://github.com/richardkiss/pycoin;
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
  };
}
