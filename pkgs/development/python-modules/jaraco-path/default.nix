{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pyobjc-framework-Cocoa,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "jaraco-path";
  version = "3.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.path";
    tag = "v${version}";
    hash = "sha256-uLkNMhB7aeDJ3fF0Ynjd8MD6+CTKKH8vsB5cH9RPcok=";
  };

  build-system = [ setuptools-scm ];

  pythonImportsCheck = [ "jaraco.path" ];

  dependencies = lib.optionals stdenv.hostPlatform.isDarwin [
    pyobjc-framework-Cocoa
  ];

  # Depend on pyobjc-framework-Cocoa on macOS
  # https://github.com/jaraco/jaraco.path/pull/10
  patches = [
    ./darwin-pyobjc-framework-Cocoa.patch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # test_is_hidden_Darwin assumes ~/Library exists and is hidden, which is not
  # true in the Nix build sandbox.
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_is_hidden_Darwin"
  ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.path/blob/${src.tag}/NEWS.rst";
    description = "Miscellaneous path functions";
    homepage = "https://github.com/jaraco/jaraco.path";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
