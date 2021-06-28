{ lib
, isPy27
, buildPythonPackage
, fetchPypi
, aiohttp
, demjson
, python
}:

buildPythonPackage rec {
  pname = "pysyncthru";
  version = "0.7.3";

  disabled = isPy27;

  src = fetchPypi {
    pname = "PySyncThru";
    inherit version;
    sha256 = "13564018a7de4fe013e195e19d7bae92aa224e0f3a32373576682722d3dbee52";
  };

  propagatedBuildInputs = [
    aiohttp
    demjson
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  # no tests on PyPI, no tags on GitHub
  doCheck = false;

  pythonImportsCheck = [ "pysyncthru" ];

  meta = with lib; {
    description = "Automated JSON API based communication with Samsung SyncThru Web Service";
    homepage = "https://github.com/nielstron/pysyncthru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
