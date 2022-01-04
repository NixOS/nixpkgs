{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J/UDIg5oRdnblU+yErlbA2LYt+bBsjJqhwYcPek1lLE=";
  };

  checkInputs = [
    hypothesis
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [
    "iso8601"
  ];

  meta = with lib; {
    description = "Module to parse ISO 8601 dates";
    homepage = "https://pyiso8601.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
