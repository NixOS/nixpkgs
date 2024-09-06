{
  lib,
  fetchFromGitHub,
  bech32,
  buildPythonPackage,
  cryptography,
  ed25519,
  ecdsa,
  gnupg,
  semver,
  mnemonic,
  unidecode,
  mock,
  pytest,
  backports-shutil-which,
  configargparse,
  python-daemon,
  pymsgbox,
  pynacl,
}:

# When changing this package, please test packages {keepkey,ledger,onlykey,trezor}-agent

buildPythonPackage rec {
  pname = "libagent";
  version = "0.15.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "trezor-agent";
    rev = "refs/tags/v${version}";
    hash = "sha256-NmpFyLjLdR9r1tc06iDNH8Tc7isUelTg13mWPrQvxSc=";
  };

  # hardcode the path to gpgconf in the libagent library
  postPatch = ''
    substituteInPlace libagent/gpg/keyring.py \
      --replace "util.which('gpgconf')" "'${gnupg}/bin/gpgconf'" \
      --replace "'gpg-connect-agent'" "'${gnupg}/bin/gpg-connect-agent'"
  '';

  propagatedBuildInputs = [
    unidecode
    backports-shutil-which
    configargparse
    python-daemon
    pymsgbox
    ecdsa
    ed25519
    mnemonic
    semver
    pynacl
    bech32
    cryptography
  ];

  nativeCheckInputs = [
    mock
    pytest
  ];

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
