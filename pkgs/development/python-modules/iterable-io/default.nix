{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "iterable-io";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "iterable-io";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6qhizeRZONxEthkk468U6Lh7ES7kgWDBfwsdZm5tuX8=";
  };

  nativeBuildInputs = [ hatchling ];

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
