{
  lib,
  aioesphomeapi,
  bleak,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  hypothesis,
  pythonOlder,
  pytest,
  pytestCheckHook,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-asyncio";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-asyncio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gXBxFf+DcSTufQxSCZmLWdBKOM5ZtL9OEehp05hS5hc=";
  };

  build-system = [ setuptools-scm ];

  pythonRelaxDeps = [ "pytest" ];

  buildInputs = [ pytest ];

  dependencies = lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  doCheck = false;
  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    tests = {
      inherit aioesphomeapi bleak;
      pytest = finalAttrs.finalPackage.overrideAttrs {
        doInstallCheck = true;
      };
    };
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_asyncio" ];

  meta = {
    description = "Library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/${finalAttrs.src.tag}/docs/reference/changelog.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
