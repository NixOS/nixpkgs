{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "url-parser";
  version = "2.1.19";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mHQ93vi10nEJWeAbi3nvBVA2E5EQX/992qGsyJglmmU=";
  };

  vendorHash = "sha256-2IHNuj4q6aVKmGlXysvieHaP2fqKDGRaYUN0/I1byuI=";

  # buildGoModule puts go in the passthru. NOTE this can be removed once
  # https://github.com/NixOS/nixpkgs/pull/527289 reaches master.
  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "go 1.26.4" "go ${finalAttrs.finalPackage.passthru.go.version}"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.BuildVersion=${finalAttrs.version}"
    "-X"
    "main.BuildDate=1970-01-01"
  ];

  meta = {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    changelog = "https://github.com/thegeeklab/url-parser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "url-parser";
  };
})
