{
  lib,
  alejandra,
  buildPythonPackage,
  fetchFromGitHub,
  mdformat,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mdformat-nix-alejandra";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aldoborrero";
    repo = "mdformat-nix-alejandra";
    tag = finalAttrs.version;
    hash = "sha256-jUXApGsxCA+pRm4m4ZiHWlxmVkqCPx3A46oQdtyKz5g=";
  };

  postPatch = ''
    substituteInPlace mdformat_nix_alejandra/__init__.py \
      --replace-fail '"alejandra"' '"${lib.getExe alejandra}"'
  '';

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "mdformat"
  ];
  dependencies = [ mdformat ];

  pythonImportsCheck = [ "mdformat_nix_alejandra" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Mdformat plugin format Nix code blocks with alejandra";
    changelog = "https://github.com/aldoborrero/mdformat-nix-alejandra/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/aldoborrero/mdformat-nix-alejandra";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
})
