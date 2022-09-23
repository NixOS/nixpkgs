{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pysoma";
  version = "0.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-U/kLaO/GBpOa9mHHlYQiWSw7sVNPaMneDURoJBqqojo=";
  };

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "api" ];

  meta = with lib; {
    description = "Python wrapper for the HTTP API provided by SOMA Connect";
    homepage = "https://pypi.org/project/pysoma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
