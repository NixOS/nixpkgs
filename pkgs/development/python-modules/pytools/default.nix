{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  platformdirs,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2024.1.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OeW7r4H6Qy5oi4LdCYAhLRj5eyPlGox6/nWSJJ/kCrE=";
  };

  build-system = [ setuptools ];

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
