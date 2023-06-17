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
  version = "2.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-igOsDHqfjD1cxcHYsTNbjkhsxKR7LNJf5Zw1kkr4a2E=";
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
    changelog = "https://github.com/cloudflare/python-cloudflare/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
