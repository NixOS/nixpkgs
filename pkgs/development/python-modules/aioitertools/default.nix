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
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wqkFW0+7dwX1YbnYYFPor10QzIRdIsMgCMQ0kLLY3Ws=";
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
