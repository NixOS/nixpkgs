{ lib
, buildPythonPackage
, fetchPypi
, requests
, ciso8601
}:

buildPythonPackage rec {
  pname = "dwdwfsapi";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8541eb93a6323bec6a2281aa06667e72b02c8e5fac40f899c402089b1c774472";
  };

  propagatedBuildInputs = [
    requests
    ciso8601
  ];

  # All tests require network access
  doCheck = false;

  pythonImportsCheck = [ "dwdwfsapi" ];

  meta = with lib; {
    description = "Python client to retrieve data provided by DWD via their geoserver WFS API";
    homepage = "https://github.com/stephan192/dwdwfsapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ elohmeier ];
  };
}
