{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, lxml
}:

buildPythonPackage rec {
  pname = "pykmtronic";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d0301882f06a0c4865c89bb6c2a381c4a1ba6fe2a7a07d56351bdf5f96c9fa5";
  };

  propagatedBuildInputs = [ aiohttp lxml ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pykmtronic" ];

  meta = with lib; {
    description = "Python client to interface with KM-Tronic web relays";
    homepage = "https://github.com/dgomes/pykmtronic";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
