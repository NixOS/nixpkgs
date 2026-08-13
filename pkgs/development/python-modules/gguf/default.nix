{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  poetry-core,
  pyprojectVersionPatchHook,

  # dependencies
  numpy,
  pyside6,
  pyyaml,
  requests,
  tqdm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gguf";
  version = "9967";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b${finalAttrs.version}";
    hash = "sha256-HgptebnnT3xOU26/UJCqQ6FSrhcoybju7SKUy4pLOKA=";
  };

  sourceRoot = "${finalAttrs.src.name}/gguf-py";

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    numpy
    pyyaml
    requests
    tqdm
  ];

  optional-dependencies = {
    gui = [ pyside6 ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gguf" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "b(.*)"
    ];
  };

  meta = {
    description = "Module for writing binary files in the GGUF format";
    homepage = "https://ggml.ai/";
    downloadPage = "https://github.com/ggml-org/llama.cpp/releases";
    changelog = "https://github.com/ggml-org/llama.cpp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mitchmindtree
      sarahec
    ];
  };
})
