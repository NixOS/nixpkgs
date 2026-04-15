{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  numpy,
  platformdirs,
  pytestCheckHook,
  typing-extensions,
  siphash24,
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2026.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e2Q4yl7N7e5C4WyMtwLCrlYqmPsmLawaOwGxIcw0vtU=";
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
