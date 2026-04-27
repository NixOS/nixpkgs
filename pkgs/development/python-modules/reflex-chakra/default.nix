{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  reflex,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "reflex-chakra";
  version = "0.8.2post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "reflex-chakra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DugZRZpGP90EFkBjpAS1XkjrNPG6WWwCQPUcEZJ0ff8=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [ reflex ];

  pythonImportsCheck = [ "reflex_chakra" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # there are no "test_*.py" files, and the
  # other files with `test_*` functions are not maintained it seems
  doCheck = false;

  meta = {
    description = "Chakra Implementation in Reflex";
    homepage = "https://github.com/reflex-dev/reflex-chakra";
    changelog = "https://github.com/reflex-dev/reflex-chakra/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
