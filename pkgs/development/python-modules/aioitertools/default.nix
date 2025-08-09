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
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wqkFW0+7dwX1YbnYYFPor10QzIRdIsMgCMQ0kLLY3Ws=";
  };

  build-system = [ flit-core ];

  dependencies = lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "aioitertools" ];

  meta = with lib; {
    description = "Implementation of itertools, builtins, and more for AsyncIO and mixed-type iterables";
    homepage = "https://aioitertools.omnilib.dev/";
    changelog = "https://github.com/omnilib/aioitertools/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ teh ];
  };
}
