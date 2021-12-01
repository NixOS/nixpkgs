{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "python-ecobee-api";
  version = "0.2.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QfVOgX/psFB/l9dPBcaHh+2v9+7LjDCUAvaEQjUrxmA=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyecobee" ];

  meta = with lib; {
    description = "Python API for talking to Ecobee thermostats";
    homepage = "https://github.com/nkgilley/python-ecobee-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
