{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, poetry-core
, pytestCheckHook
, pytz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J/UDIg5oRdnblU+yErlbA2LYt+bBsjJqhwYcPek1lLE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    hypothesis
    pytestCheckHook
    pytz
  ];

  pytestFlagsArray = [
    "iso8601"
  ];

  pythonImportsCheck = [
    "iso8601"
  ];

  meta = with lib; {
    description = "Simple module to parse ISO 8601 dates";
    homepage = "https://pyiso8601.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
