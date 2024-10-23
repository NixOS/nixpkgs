{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  callPackage,
  testers, xunit-viewer,
}:
let
  version = "10.1.1";
in
buildNpmPackage {
  pname = "xunit-viewer";
  inherit version;

  src = fetchFromGitHub {
    owner = "lukejpreston";
    repo = "xunit-viewer";
    rev = "v${version}";
    hash = "sha256-RTUzx8/fwqNvX+zRdkijRI5gr7h1kWZ268vpIdAC3pw=";
  };

  npmDepsHash = "sha256-ahDgrN9y3v418m5n4lA15dCqWpBDecgiafvZRzo4w2c=";

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
