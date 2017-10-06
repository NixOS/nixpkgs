{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa
, semver, keepkey, trezor, mnemonic, ledgerblue, unidecode
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libagent";
  version = "0.9.2";

  src = fetchPypi{
    inherit pname version;
    sha256 = "07rici6zsk636383vpasmi2f0058d5560qjrdybgr4vn1b6drinn";
  };

  buildInputs = [
    ed25519 ecdsa semver keepkey
    trezor mnemonic ledgerblue unidecode
  ];

  meta = with stdenv.lib; {
    description = "Using hardware wallets as SSH/GPG agent";
    homepage = https://github.com/romanz/trezor-agent;
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
