{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, python-dateutil
}:

buildPythonPackage rec {
  pname = "pyplaato";
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nykbkv2fg1x5min07cbi44x6am48f5gw3mnyj7x2kpmj6sqfpqp";
  };

  propagatedBuildInputs = [ aiohttp python-dateutil ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyplaato" ];

  meta = with lib; {
    description = "Python API client for fetching Plaato data";
    homepage = "https://github.com/JohNan/pyplaato";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
