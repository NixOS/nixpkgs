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
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c5lg03x0x3vZvVRqdlYsy1gf49SCD/XDFB60nIOf2o8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
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
