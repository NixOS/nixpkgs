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
  version = "2025.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nGqLnXCnn6yEbwysrAgwtTjQhFjhD05gRshF1UDN6Jk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    platformdirs
    typing-extensions
  ];

  optional-dependencies = {
    numpy = [ numpy ];
    siphash = [ siphash24 ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.siphash;

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
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
