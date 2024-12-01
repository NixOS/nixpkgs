{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "viddy";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${version}";
    hash = "sha256-lk992sI5kXo5Q8+rgBCKo/knV3/6uPs83Zj27JQcR6M=";
  };

  cargoHash = "sha256-9xXUlsRGKw0rvIYAr4pMDh6oD/ZjBYPaL0g6dCC5sCo=";

  # requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  env.VERGEN_BUILD_DATE = "2024-11-16"; # managed via the update script
  env.VERGEN_GIT_DESCRIBE = "Nixpkgs";

  passthru.updateScript.command = [ ./update.sh ];

  meta = {
    description = "Modern watch command, time machine and pager etc.";
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
