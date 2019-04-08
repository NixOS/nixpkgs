{ stdenv, fetchPypi, buildPythonPackage, pytest, pyhamcrest }:

buildPythonPackage rec {
  pname = "base58";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a793c599979c497800eb414c852b80866f28daaed5494703fc129592cc83e60";
  };

  checkInputs = [ pytest pyhamcrest ];
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Base58 and Base58Check implementation";
    homepage = https://github.com/keis/base58;
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
