{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  callPackage,
  testers,
  xunit-viewer,
}:
let
  version = "10.6.1";
in
buildNpmPackage {
  pname = "xunit-viewer";
  inherit version;

  src = fetchFromGitHub {
    owner = "lukejpreston";
    repo = "xunit-viewer";
    rev = "v${version}";
    hash = "sha256-n9k1Z/wofExG6k/BxtkU8M+Lo3XdCgCh8VFj9jcwL1Q=";
  };

  npmDepsHash = "sha256-6PV0+G1gzUWUjOfwRtVeALVFFiwkCAB33yB9W0PCGfc=";

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    version = testers.testVersion {
      package = xunit-viewer;
      version = "unknown"; # broken, but at least it runs
    };
    example = callPackage ./test/example.nix { };
  };

  meta = {
    description = "View your xunit results using JavaScript";
    homepage = "https://lukejpreston.github.io/xunit-viewer";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.all;
  };
}
