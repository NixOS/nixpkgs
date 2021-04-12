{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "pythonegardia";
  version = "1.0.40";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rv6m5zaflf3nanpl1xmfmfcpg8kzcnmniq1hhgrybsspkc7mvry";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests, only two test file for manual interaction
  doCheck = false;
  pythonImportsCheck = [ "pythonegardia" ];

  meta = with lib; {
    description = "Python interface with Egardia/Woonveilig alarms";
    homepage = "https://github.com/jeroenterheerdt/python-egardia";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
