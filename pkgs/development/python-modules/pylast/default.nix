{ lib
, buildPythonPackage
, certifi
, fetchPypi
, flaky
, importlib-metadata
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "4.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2m6+pQYBmvVxlBw1yLSAKr3kZ5WS1S0TZ1ZQ3ER+bCk=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    certifi
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    flaky
  ];

  pythonImportsCheck = [
    "pylast"
  ];

  meta = with lib; {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
