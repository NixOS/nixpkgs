{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  hatchling,
  pydantic,
  docker,
  kubernetes,
  mcp,
  podman,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-sandbox";
  version = "0.3.45";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vndee";
    repo = "llm-sandbox";
    tag = finalAttrs.version;
    hash = "sha256-t/6e2hepZU8nG9bZSS6vhFF89dSjwsvwxvqn1aaOB3A=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [ pydantic ];

  optional-dependencies = {
    docker = [ docker ];
    k8s = [ kubernetes ];
    podman = [
      docker
      podman
    ];
    mcp-docker = [
      docker
      mcp
    ];
    mcp-k8s = [
      kubernetes
      mcp
    ];
    mcp-podman = [
      docker
      mcp
      podman
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "llm_sandbox" ];

  meta = {
    description = "Lightweight and portable LLM sandbox runtime";
    homepage = "https://github.com/vndee/llm-sandbox";
    changelog = "https://github.com/vndee/llm-sandbox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
  };
})
