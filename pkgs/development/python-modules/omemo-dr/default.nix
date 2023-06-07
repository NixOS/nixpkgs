{ lib, buildPythonPackage, fetchPypi, cryptography, protobuf }:

buildPythonPackage rec {
  pname = "omemo-dr";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha512-rR1Dk2+U1HoBsfTzqOMb+B0WEycUsp9u9arISpB6i+w/0QFDMM3AFpz6AuZPeBXRH/Tsiiqjrs2RQXSNLsRpsQ==";
  };

  propagatedBuildInputs = [ cryptography protobuf ];

  meta = with lib; {
    homepage = "https://dev.gajim.org/gajim/omemo-dr";
    description = "OMEMO Double Ratchet";
    license = licenses.gpl3;
    maintainers = with maintainers; [ servilio ];
  };
}
