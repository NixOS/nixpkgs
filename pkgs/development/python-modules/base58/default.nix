{ stdenv, fetchPypi, buildPythonPackage, isPy27, pytest, pyhamcrest }:

buildPythonPackage rec {
  pname = "base58";
  version = "2.0.0";
  disabled = isPy27; # python 2 abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "c83584a8b917dc52dd634307137f2ad2721a9efb4f1de32fc7eaaaf87844177e";
  };

  checkInputs = [ pytest pyhamcrest ];
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Base58 and Base58Check implementation";
    homepage = "https://github.com/keis/base58";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
