{ buildPythonPackage, fetchPypi, lib, ipaddress, isPy3k }:

buildPythonPackage rec {
  pname = "piccata";
  version = "1.0.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "45f6c98c2ea809d445040888117f99bc3ee843490d86fecc5805ff5ea41508f7";
  };

  propagatedBuildInputs = [ ipaddress ];

  meta = {
    description = "Simple CoAP (RFC7252) toolkit";
    homepage = "https://github.com/NordicSemiconductor/piccata";
    maintainers = with lib.maintainers; [ gebner ];
  };
}
