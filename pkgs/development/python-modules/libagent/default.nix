{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa , semver, mnemonic,
  unidecode, mock, pytest , backports-shutil-which, ConfigArgParse,
  python-daemon, pymsgbox }:

buildPythonPackage rec {
  pname = "libagent";
  version = "0.12.1";

  src = fetchPypi{
    inherit pname version;
    sha256 = "f21515a217125b7c8cbb1f53327d1d4363c1b980a7e246feabf91aed9b1c51e5";
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
