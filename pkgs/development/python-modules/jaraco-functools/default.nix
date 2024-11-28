{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  jaraco-classes,
  more-itertools,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jaraco-functools";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jaraco_functools";
    inherit version;
    hash = "sha256-cPfg4q4HZJjiElYjJegFIE/Akte0wX4OhslZ4klwGp0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ more-itertools ];

  nativeCheckInputs = [
    jaraco-classes
    pytestCheckHook
  ];

  # test is flaky on darwin
  disabledTests = if stdenv.hostPlatform.isDarwin then [ "test_function_throttled" ] else null;

  pythonNamespaces = [ "jaraco" ];

  pythonImportsCheck = [ "jaraco.functools" ];

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    changelog = "https://github.com/jaraco/jaraco.functools/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
