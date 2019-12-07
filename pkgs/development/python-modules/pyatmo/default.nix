{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b884402c62d589a38444e8f4b3892b18312e8f9442cd8d12e7ec01c698328f54";
  };

  propagatedBuildInputs = [ requests ];

  # Upstream provides no unit tests.
  doCheck = false;

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    license = licenses.mit;
    homepage = https://github.com/jabesq/netatmo-api-python;
    maintainers = with maintainers; [ delroth ];
  };
}
