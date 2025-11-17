{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "viddy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${version}";
    hash = "sha256-ZdDe0ymPkj0ZGiPLo1Y0qMDk2SsUcPsSStay+Tuf4p0=";
  };

  cargoHash = "sha256-Bp3t/fjaFeouIoKlRvQPVDlc46Ggitfx6HUXE+RZN0A=";

  env.VERGEN_BUILD_DATE = "2024-11-28"; # managed via the update script
  env.VERGEN_GIT_DESCRIBE = "Nixpkgs";

  passthru.updateScript.command = [ ./update.sh ];

  meta = {
    description = "Modern `watch` command";
    changelog = "https://github.com/sachaos/viddy/releases";
    homepage = "https://github.com/sachaos/viddy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      j-hui
      phanirithvij
    ];
    mainProgram = "viddy";
  };
}
