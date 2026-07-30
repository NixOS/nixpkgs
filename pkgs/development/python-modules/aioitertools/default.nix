{
  lib,
  buildPythonPackage,
  fetchPypi,

  # native
  flit-core,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioitertools";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YgvSQazAu7nsgZ8ashWGaHG0u9H3ODalX3mSAO6GlQw=";
  };

  build-system = [ flit-core ];

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
