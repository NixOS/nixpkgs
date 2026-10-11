{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "y4";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "y4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pb7pTTPpRkuH24cnscdmHUpegdkZPyXjHBVUmrd6HlY=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    jq
    pyyaml
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/managarm/y4/releases/tag/${finalAttrs.src.tag}";
    description = "Purely functional DSL to process YAML";
    homepage = "https://github.com/managarm/y4";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lzcunt
    ];
    mainProgram = "y4";
  };
})
