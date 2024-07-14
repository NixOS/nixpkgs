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
    hash = "sha256-ImW6nGpFlP95j+SAhW6ja/5tiue6IZC3T5ZmUQUw8g8=";
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
