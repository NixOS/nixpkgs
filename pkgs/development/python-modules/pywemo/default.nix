{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.6.4";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1hm1vs6m65vqar0lcjnynz0d9y9ri5s75fzhvp0yfjkcnp06gnfa";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    ifaddr
    requests
    urllib3
    lxml
  ];

  checkInputs = [
    pytest-vcr
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/pywemo/pywemo/issues/264
    "test_rules_db_from_device"
  ];

  pythonImportsCheck = [ "pywemo" ];

  meta = with lib; {
    description = "Python module to discover and control WeMo devices";
    homepage = "https://github.com/pywemo/pywemo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
