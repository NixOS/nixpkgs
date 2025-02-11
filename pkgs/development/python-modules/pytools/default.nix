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
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2025.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gPjj8/d1bQyb1XmHnDUo1U5CKEO1CiiKnDtro+Dqwos=";
  };

  build-system = [ hatchling ];

  dependencies = [
    platformdirs
    typing-extensions
  ];

  optional-dependencies = {
    numpy = [ numpy ];
    # siphash = [ siphash ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pytools"
    "pytools.batchjob"
    "pytools.lex"
  ];

  disabledTests = [
    # siphash is not available
    "test_class_hashing"
    "test_dataclass_hashing"
    "test_datetime_hashing"
    "test_hash_function"
  ];

  meta = {
    description = "Miscellaneous Python lifesavers";
    homepage = "https://github.com/inducer/pytools/";
    changelog = "https://github.com/inducer/pytools/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
