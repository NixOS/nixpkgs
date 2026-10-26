{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "diskcache-stubs";
  version = "5.6.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phi-friday";
    repo = "diskcache-stubs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yYds/00K9XyJirreBGG/r30HZTyBQbFa6N4EizsmdKg=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "diskcache-stubs" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Diskcache stubs";
    homepage = "https://github.com/phi-friday/diskcache-stubs";
    changelog = "https://github.com/phi-friday/diskcache-stubs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
