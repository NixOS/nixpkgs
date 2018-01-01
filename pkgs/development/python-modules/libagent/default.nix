{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa
, semver, keepkey, trezor, mnemonic, ledgerblue
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libagent";
  version = "0.9.5";

  src = fetchPypi{
    inherit pname version;
    sha256 = "982b81c19dc9ee1158dc32fedbe1c36aff2b6872fa0dd42173b639b965ccfb2e";
  };

  buildInputs = [
    ed25519 ecdsa semver keepkey
    trezor mnemonic ledgerblue
  ];

  meta = with stdenv.lib; {
    description = "Using hardware wallets as SSH/GPG agent";
    homepage = https://github.com/romanz/trezor-agent;
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
    broken = true;
  };
}
