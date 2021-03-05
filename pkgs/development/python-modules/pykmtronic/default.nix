{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, lxml
}:

buildPythonPackage rec {
  pname = "pykmtronic";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p0i7g4k8ggmzargdi3ch55id04j5qjlhv8hap2162gc77b16d59";
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
