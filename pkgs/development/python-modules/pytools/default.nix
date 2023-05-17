{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, decorator
, numpy
, platformdirs
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2022.1.14";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QQFzcWELsqA2hVl8UoUgXmWXx/F3OD2VyLhxJEsSwU4=";
  };

  propagatedBuildInputs = [
    decorator
    numpy
    platformdirs
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytools"
    "pytools.batchjob"
    "pytools.lex"
  ];

  meta = {
    homepage = "https://github.com/inducer/pytools/";
    description = "Miscellaneous Python lifesavers.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
