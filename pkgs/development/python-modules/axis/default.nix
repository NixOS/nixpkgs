{ lib
, async-timeout
, attrs
, buildPythonPackage
, fetchFromGitHub
, httpx
, orjson
, packaging
, pythonOlder
, xmltodict
}:

buildPythonPackage rec {
  pname = "axis";
  version = "50";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Zu8hT6t7ZxlgXQKb2o20FpB15n9y/+n1qMctzcRP8F8=";
  };

  propagatedBuildInputs = [
    async-timeout
    attrs
    httpx
    orjson
    packaging
    xmltodict
  ];

  # Tests requires a server on localhost
  doCheck = false;

  pythonImportsCheck = [
    "axis"
  ];

  meta = with lib; {
    description = "Python library for communicating with devices from Axis Communications";
    homepage = "https://github.com/Kane610/axis";
    changelog = "https://github.com/Kane610/axis/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
