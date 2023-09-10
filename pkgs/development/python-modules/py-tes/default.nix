{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, future
, python-dateutil
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "py-tes";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ohsu-comp-bio";
    repo = pname;
    rev = version;
    hash = "sha256-HZeyCQHiqfdquWQD5axS73JDjDMUieONwm5VyA+vTFk=";
  };

  propagatedBuildInputs = [
    attrs
    future
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "tes"
  ];

  meta = with lib; {
    description = "Python SDK for the GA4GH Task Execution API";
    homepage = "https://github.com/ohsu-comp-bio/py-tes";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
