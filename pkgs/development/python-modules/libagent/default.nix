{ lib, fetchFromGitHub, buildPythonPackage, ed25519, ecdsa , semver, mnemonic,
  unidecode, mock, pytest , backports-shutil-which, configargparse,
  python-daemon, pymsgbox }:

# XXX: when changing this package, please test the package onlykey-agent.

buildPythonPackage rec {
  pname = "libagent";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "trezor-agent";
    rev = "v${version}";
    sha256 = "16y1y9ahcv3wj7f0v4mfiwzkmn2hz1iv7y13cgr57sxa3ymyqx6c";
  };

  propagatedBuildInputs = [ unidecode backports-shutil-which configargparse
    python-daemon pymsgbox ecdsa ed25519 mnemonic semver ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test libagent/tests
  '';

  meta = with lib; {
    description = "Using hardware wallets as SSH/GPG agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ np ];
  };
}
