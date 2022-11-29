{ lib
, buildPythonPackage
, fetchPypi
, attrs
, beautifulsoup4
, requests
, future
, pyyaml
, jsonlines
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cloudflare";
  version = "2.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wLgb7HnDSX3OVCVNlBd97iIg+g0ngaDWk7Jcs5fKc7k=";
  };

  propagatedBuildInputs = [
    attrs
    beautifulsoup4
    requests
    future
    pyyaml
    jsonlines
  ];

  # no tests associated with package
  doCheck = false;

  pythonImportsCheck = [
    "CloudFlare"
  ];

  meta = with lib; {
    description = "Python wrapper for the Cloudflare v4 API";
    homepage = "https://github.com/cloudflare/python-cloudflare";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
