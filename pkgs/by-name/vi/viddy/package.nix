{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "viddy";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${version}";
    hash = "sha256-r+zgZutBwNRLYNltdSaIB5lS4qHAhI5XL3iFF+FVd64=";
  };

  cargoHash = "sha256-rEz3GFfqtSzZa0r4Nwbu3gEf7GhsOkfawaFaNplD/tE=";

  # requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  env.VERGEN_BUILD_DATE = "2024-10-13"; # managed via the update script
  env.VERGEN_GIT_DESCRIBE = "Nixpkgs";

  passthru.updateScript.command = [ ./update.sh ];

  meta = with lib; {
    description = "Modern watch command, time machine and pager etc.";
    changelog = "https://github.com/sachaos/viddy/releases";
    homepage = "https://github.com/sachaos/viddy";
    license = licenses.mit;
    maintainers = with maintainers; [
      j-hui
      phanirithvij
    ];
    mainProgram = "viddy";
  };
}
