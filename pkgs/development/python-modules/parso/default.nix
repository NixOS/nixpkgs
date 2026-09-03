{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "parso";
  version = "0.8.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "parso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vpWoxLIvNt4QQh/r57iAvX3Zebet3mihb5efOWLhYI8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python Parser";
    homepage = "https://parso.readthedocs.io/en/latest/";
    changelog = "https://github.com/davidhalter/parso/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
  };
})
