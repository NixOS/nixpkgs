{ lib
, buildPythonPackage
, fetchPypi
, justbases
, hypothesis
}:

buildPythonPackage rec {
  pname = "justbytes";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qrMO9X0v5yYjeWa72mogegR+ii8tCi+o7qZ+Aff2wZQ=";
  };

  propagatedBuildInputs = [ justbases ];
  checkInputs = [ hypothesis ];

  meta = with lib; {
    description = "computing with and displaying bytes";
    homepage = "https://pythonhosted.org/justbytes";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
