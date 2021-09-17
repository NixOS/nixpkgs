{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "pythonegardia";
  version = "1.0.51";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b99217e34c59bfae059db400acef99d3d32237d13da6fdce9e0d4decc9a07e61";
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
