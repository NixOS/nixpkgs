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
  version = "2023.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Q5CUiCu+h/5JTQrZY/wLcM1l8IfuI16Y/lEG/LnpQ4=";
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
