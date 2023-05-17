{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cronsim";
  version = "2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ebFYIOANXZLmM6cbovwBCJH8Wr/HlJbOR9YGp8Jw7pc=";
  };

  nativeCheckInputs = [
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
