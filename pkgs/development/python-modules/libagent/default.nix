{ stdenv, fetchPypi, buildPythonPackage, ed25519, ecdsa
, semver, keepkey, trezor, mnemonic, ledgerblue, unidecode, mock, pytest
}:

buildPythonPackage rec {
  pname = "libagent";
  version = "0.11.3";

  src = fetchPypi{
    inherit pname version;
    sha256 = "cb6199c3572e1223756465e758fb525e7f406a4808e9d7cfdddf089bec710047";
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
