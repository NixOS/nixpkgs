{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  decorator,
  numpy,
  platformdirs,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2024.1.5";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jDd7sf/ctRAzAbjn6U8By+Nlc6AeAgQ0/qlikbHxrBk=";
  };

  propagatedBuildInputs = [
    decorator
    numpy
    platformdirs
  ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pytools"
    "pytools.batchjob"
    "pytools.lex"
  ];

  meta = {
    homepage = "https://github.com/inducer/pytools/";
    description = "Miscellaneous Python lifesavers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
