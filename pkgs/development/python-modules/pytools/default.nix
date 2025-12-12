{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  numpy,
  platformdirs,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
  siphash24,
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2025.2.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nLgr50dW0ZIcArrTx2fr3kZ50tFDqFpMNY0y9lRuVG8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    platformdirs
    siphash24
    typing-extensions
  ];

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytools"
    "pytools.batchjob"
    "pytools.lex"
  ];

  meta = {
    description = "Miscellaneous Python lifesavers";
    homepage = "https://github.com/inducer/pytools/";
    changelog = "https://github.com/inducer/pytools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
