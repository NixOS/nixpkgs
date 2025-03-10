{
  lib,
  buildPythonPackage,
  fetchPypi,
  ledgerblue,
  setuptools,
  libagent,
  wheel,
}:

buildPythonPackage rec {
  pname = "ledger-agent";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "ledger_agent";
    inherit version;
    sha256 = "03zj602m2rln9yvr08dswy56vzkbldp8b074ixwzz525dafblr92";
  };

  propagatedBuildInputs = [
    ledgerblue
    libagent
    setuptools
    wheel
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Using Ledger as hardware-based SSH/PGP agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      hkjn
      np
      mmahut
    ];
  };
}
