{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa , semver, mnemonic,
  unidecode, mock, pytest , backports-shutil-which, ConfigArgParse,
  python-daemon, pymsgbox }:

buildPythonPackage rec {
  pname = "libagent";
  version = "0.13.0";

  src = fetchPypi{
    inherit pname version;
    sha256 = "ecd6854ba8f04d04e39cb00ae3a179d6a1d5dc8e0b60ac5208c0a62e10e3106e";
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
