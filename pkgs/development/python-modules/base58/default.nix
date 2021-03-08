{ lib, stdenv, fetchPypi, buildPythonPackage, isPy27, pytest, pyhamcrest }:

buildPythonPackage rec {
  pname = "base58";
  version = "2.0.1";
  disabled = isPy27; # python 2 abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "365c9561d9babac1b5f18ee797508cd54937a724b6e419a130abad69cec5ca79";
  };

  checkInputs = [ pytest pyhamcrest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
