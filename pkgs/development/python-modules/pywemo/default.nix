{ lib
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, ifaddr
, lxml
, poetry-core
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "pywemo";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-+AdNT7ClT8JkYLkwk+IVNWgXGS04WNtENOtqmbjv7nQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    ifaddr
    requests
    urllib3
    lxml
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    hypothesis
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pywemo"
  ];

  meta = with lib; {
    description = "Python module to discover and control WeMo devices";
    homepage = "https://github.com/pywemo/pywemo";
    changelog = "https://github.com/pywemo/pywemo/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
