{ stdenv, fetchFromGitHub, buildPythonPackage, pytest, pyhamcrest }:

buildPythonPackage rec {
  pname = "base58";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "keis";
    repo = "base58";
    rev = "v${version}";
    sha256 = "0f8isdpvbgw0sqn9bj7hk47y8akpvdl8sn6rkszla0xb92ywj0f6";
  };

  buildInputs = [ pytest pyhamcrest ];
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
