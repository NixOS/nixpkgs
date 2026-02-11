{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "unpackerr";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-uQwpdgV6ksouW9JTuiiuQjxBGOE/ypDW769kNJgWrHw=";
  };

  vendorHash = "sha256-wWIw0gNn5tqRq0udzPy/n2OkiIVESpSotOSn2YlBNS4=";

  ldflags = [
    "-s"
    "-w"
    "-X golift.io/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = [ ];
    license = lib.licenses.mit;
    mainProgram = "unpackerr";
  };
})
