{ lib
, buildPythonPackage
, fetchPypi
, requests
, ciso8601
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dwdwfsapi";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zeSV2acjtSWUYnrMjEBtrSPlXRvrNQRX5SYPYHnaOy0=";
  };

  propagatedBuildInputs = [
    requests
    ciso8601
  ];

  # All tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "dwdwfsapi"
  ];

  meta = with lib; {
    description = "Python client to retrieve data provided by DWD via their geoserver WFS API";
    homepage = "https://github.com/stephan192/dwdwfsapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ elohmeier ];
  };
}
