{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa
, semver, keepkey, trezor, mnemonic, ledgerblue, unidecode, mock, pytest
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libagent";
  version = "0.9.8";

  src = fetchPypi{
    inherit pname version;
    sha256 = "7e7d62cedef9d1291b8e77abc463d50b3d685dfd953611d55a0414c12276aa78";
  };

  buildInputs = [
    ed25519 ecdsa semver keepkey
    trezor mnemonic ledgerblue
  ];

  propagatedBuildInputs = [ unidecode ];

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
