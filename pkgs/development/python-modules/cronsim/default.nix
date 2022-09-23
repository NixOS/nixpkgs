{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cronsim";
  version = "2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LMMZni8Cipo10mxAQbRadWpPvum76JQuzlrLvFvTt5o=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cronsim"
  ];

  meta = with lib; {
    description = "Cron expression parser and evaluator";
    homepage = "https://github.com/cuu508/cronsim";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
  };
}
