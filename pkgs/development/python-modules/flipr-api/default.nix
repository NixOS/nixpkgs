{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, requests-mock
, pythonOlder
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, requests
}:

buildPythonPackage rec {
  pname = "flipr-api";
  version = "1.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cnico";
    repo = pname;
    rev = version;
    sha256 = "sha256-/G92WkWUr3T5T7VVzMERFVmLDfLz6m9rlZLQZCBQbCI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  checkInputs = [
    requests-mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "flipr_api"
  ];

  meta = with lib; {
    description = "Python client for Flipr API";
    homepage = "https://github.com/cnico/flipr-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
