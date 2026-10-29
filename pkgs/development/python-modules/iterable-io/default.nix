{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iterable-io";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "iterable-io";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mS8x3M0DNnwW6Ov3TG8b2J702rjOnZT9r38fsIUXkro=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "iterableio" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library to adapt iterables to a file-like interface";
    homepage = "https://github.com/pR0Ps/iterable-io";
    changelog = "https://github.com/pR0Ps/iterable-io/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.mjoerg ];
  };
})
