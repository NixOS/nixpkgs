{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "parso";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35704a43a3c113cce4de228ddb39aab374b8004f4f2407d070b6a2ca784ce8a2";
  };

  checkInputs = [ pytest ];

  meta = {
    description = "A Python Parser";
    homepage = https://github.com/davidhalter/parso;
    license = lib.licenses.mit;
  };

}
