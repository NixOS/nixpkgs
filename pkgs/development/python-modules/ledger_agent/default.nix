{ stdenv
, buildPythonPackage
, fetchPypi
, ledgerblue
, setuptools
, libagent
, wheel
}:

buildPythonPackage rec {
  pname = "ledger_agent";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03zj602m2rln9yvr08dswy56vzkbldp8b074ixwzz525dafblr92";
  };

  propagatedBuildInputs = [
    ledgerblue libagent setuptools wheel
  ];

  meta = with stdenv.lib; {
    description = "Using Ledger as hardware-based SSH/PGP agent";
    homepage = https://github.com/romanz/trezor-agent;
    license = licenses.gpl3;
    maintainers = with maintainers; [ hkjn np mmahut ];
  };
}
