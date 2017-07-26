{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa
, semver, keepkey, trezor, mnemonic, ledgerblue
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libagent";
  version = "0.9.1";

  src = fetchPypi{
    inherit pname version;
    sha256 = "1g19lsid7lqw567w31fif89w088lzbgh27xpb1pshjk1gvags3bc";
  };

  buildInputs = [
    ed25519 ecdsa semver keepkey
    trezor mnemonic ledgerblue
  ];

  meta = with stdenv.lib; {
    description = "Using hardware wallets as SSH/GPG agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
