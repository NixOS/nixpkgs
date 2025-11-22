{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # native
  flit-core,

  # propagates
  typing-extensions,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioitertools";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YgvSQazAu7nsgZ8ashWGaHG0u9H3ODalX3mSAO6GlQw=";
  };

  build-system = [ flit-core ];

  dependencies = lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "aioitertools" ];

  meta = {
    description = "Implementation of itertools, builtins, and more for AsyncIO and mixed-type iterables";
    homepage = "https://aioitertools.omnilib.dev/";
    changelog = "https://github.com/omnilib/aioitertools/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh ];
  };
}
