{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, ciso8601
}:

buildPythonPackage rec {
  pname = "dwdwfsapi";
  version = "1.0.4";

  src = fetchFromGitHub {
     owner = "stephan192";
     repo = "dwdwfsapi";
     rev = "v1.0.4";
     sha256 = "1lg067nfqjqc12nwmwr4b40vbdhq62mimmmx16s3sgxdiv7kmcxp";
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
