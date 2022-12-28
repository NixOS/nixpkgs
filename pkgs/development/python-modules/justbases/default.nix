{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
}:

buildPythonPackage rec {
  pname = "justbases";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vQEfC8Z7xMM/fhBG6jSuhLEP/Iece5Rje1yqbpjVuPg=";
  };

  checkInputs = [ hypothesis ];

  meta = with lib; {
    description = "conversion of ints and rationals to any base";
    homepage = "https://pythonhosted.org/justbases";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
