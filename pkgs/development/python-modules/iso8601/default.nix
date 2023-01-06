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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MoEee4He7iBj6m0ulPiBmobR84EeSdI2I6QfqDK+8D8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    # "hypothesis" indirectly depends on iso8601 to build its documentation
    (hypothesis.override { enableDocumentation = false; })
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
