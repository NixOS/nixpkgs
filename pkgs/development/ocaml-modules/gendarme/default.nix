{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  nix-update-script,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "gendarme";
  version = "0.6";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitHub {
    owner = "bensmrs";
    repo = "gendarme";
    tag = finalAttrs.version;
    hash = "sha256-oXJq2lG8XcF/yGtIsomqYDG5sGRPvAiG2ZtKmLaZgN0=";
  };

  propagatedBuildInputs = [
    ppxlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Marshalling library for OCaml";
    homepage = "https://github.com/bensmrs/gendarme";
    changelog = "https://github.com/bensmrs/gendarme/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = with lib.teams; [ ngi ];
  };
})
