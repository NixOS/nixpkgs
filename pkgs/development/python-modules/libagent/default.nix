{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa
, semver, keepkey, trezor, mnemonic, ledgerblue, unidecode, mock, pytest
}:

buildPythonPackage rec {
  pname = "libagent";
  version = "0.12.0";

  src = fetchPypi{
    inherit pname version;
    sha256 = "55af1ad2a6c95aef1fc5588c2002c9e54edbb14e248776b64d00628235ceda3e";
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
