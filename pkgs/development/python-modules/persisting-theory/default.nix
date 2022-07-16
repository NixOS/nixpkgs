{ lib, buildPythonPackage, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "persisting-theory";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-D4QPoiJHvKpRQJTafzsmxgI1lCmrEtLNiL4GtJozYpA=";
  };

  checkInputs = [ nose ];

  checkPhase = "nosetests";

  meta = with lib; {
    homepage = "https://code.eliotberriot.com/eliotberriot/persisting-theory";
    description = "Automate data discovering and access inside a list of packages";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
