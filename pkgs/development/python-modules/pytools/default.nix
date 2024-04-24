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
  version = "2024.1.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LIjt+pkMjjJRZ8N2WfseEKPBEz3691K719hFZAK43P8=";
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
