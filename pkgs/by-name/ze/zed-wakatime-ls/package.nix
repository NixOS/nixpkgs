{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

# Usage:
# Add "zed-wakatime-ls" to programs.zed-editor.extraPackages in home-manager
# or just globally in home.packages or environment.systemPackages
# to allow the WakaTime extension to find and run the language server
# This will resolve https://github.com/wakatime/zed-wakatime/issues/55
# without requiring nix-ld

rustPlatform.buildRustPackage rec {
  pname = "zed-wakatime-ls";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    rev = "v${version}";
    hash = "sha256-Jmm+eRHMNBkc6ZzadvkWrfsb+bwEBNM0fnXU4dJ0NgE=";
  };

  buildAndTestSubdir = "wakatime-ls";
  doCheck = false; # No tests exist

  cargoHash = "sha256-x2axmHinxYZ2VEddeCTqMJd8ok0KgAVdUhbWaOdRA30=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;

  meta = {
    description = "WakatTime language server for Zed";
    homepage = "https://github.com/wakatime/zed-wakatime";
    changelog = "https://github.com/wakatime/zed-wakatime/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krishnans2006 ];
    mainProgram = "wakatime-ls";
  };
}
