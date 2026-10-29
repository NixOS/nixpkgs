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

buildPythonPackage (finalAttrs: {
  pname = "pytools";
  version = "2026.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Jg4NiMmpA8Zc/jT76Bh2T0Sj+W5yLho2Rc5NWWrdIrE=";
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
    changelog = "https://github.com/inducer/pytools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
