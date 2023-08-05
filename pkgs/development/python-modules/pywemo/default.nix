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
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-6aigzwHP9iAQF4GKKQfnZl9sAbwZfOAG/xPf6ay7rGs=";
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
