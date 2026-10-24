{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-forked";
  version = "1.7.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-forked";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RPuJAukcfVjZHZQ+a/bxADhY3BJKmSe3S/6eHUG3kYQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    changelog = "https://github.com/pytest-dev/pytest-forked/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Run tests in isolated forked subprocesses";
    homepage = "https://github.com/pytest-dev/pytest-forked";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
