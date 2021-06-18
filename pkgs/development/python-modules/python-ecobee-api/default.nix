{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "python-ecobee-api";
  version = "0.2.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c39f5aac854a2fb8fb33f41b351769a92ff784bc6112e7a5c1b9e1949a0fefe";
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
