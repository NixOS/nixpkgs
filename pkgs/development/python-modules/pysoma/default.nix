{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pysoma";
  version = "0.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q8afi6m3mfh0rfpghyvx6z76kgrpkbnlqzbs4p8ax13n0fnlkdi";
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
