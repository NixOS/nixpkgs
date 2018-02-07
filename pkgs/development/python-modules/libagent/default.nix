{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa
, semver, keepkey, trezor, mnemonic, ledgerblue, unidecode, mock, pytest
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "libagent";
  version = "0.9.7";

  src = fetchPypi{
    inherit pname version;
    sha256 = "3ae14dc14859f7b4b92583ab0d40884ac07f26dbe00c7b747df2d50f4b1af098";
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
