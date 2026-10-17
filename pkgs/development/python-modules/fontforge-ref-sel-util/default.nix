{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:
buildPythonPackage (finalAttrs: {
  pname = "fontforge-ref-sel-util";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mihailjp";
    repo = "fontforge-ref-sel-util";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qMwrcnt6LNEzOPDfibXkN5CYnkboMes4W9oHX9bTSBA=";
  };

  build-system = [ setuptools ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FontForge utility plugin on references and selections";
    homepage = "https://github.com/MihailJP/fontforge-ref-sel-util";
    changelog = "https://github.com/MihailJP/fontforge-ref-sel-util/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      acidbong
    ];
  };
})
