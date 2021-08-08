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
  version = "0.6.6";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "04h4av65x0a2iv3a4rpsq19m9pi7wk8j447rr5z7jwap870gs8nd";
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

  checkInputs = [
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pywemo" ];

  meta = with lib; {
    description = "Python module to discover and control WeMo devices";
    homepage = "https://github.com/pywemo/pywemo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
