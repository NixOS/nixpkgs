{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa , semver, mnemonic,
  unidecode, mock, pytest , backports-shutil-which, ConfigArgParse,
  python-daemon, pymsgbox }:

buildPythonPackage rec {
  pname = "libagent";
  version = "0.13.1";

  src = fetchPypi{
    inherit pname version;
    sha256 = "b9afa0851f668612702fcd648cee47af4dc7cfe4f86d4c4a84b1a6b4a4960b41";
  };

  propagatedBuildInputs = [ unidecode backports-shutil-which ConfigArgParse
    python-daemon pymsgbox ecdsa ed25519 mnemonic semver ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test libagent/tests
  '';

  meta = with stdenv.lib; {
    description = "Using hardware wallets as SSH/GPG agent";
    homepage = https://github.com/romanz/trezor-agent;
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
