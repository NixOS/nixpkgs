{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zed-wakatime-ls";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jmm+eRHMNBkc6ZzadvkWrfsb+bwEBNM0fnXU4dJ0NgE=";
  };

  buildAndTestSubdir = "wakatime-ls";

  cargoHash = "sha256-x2axmHinxYZ2VEddeCTqMJd8ok0KgAVdUhbWaOdRA30=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  __structuredAttrs = true;

  meta = {
    description = "WakaTime language server for Zed";
    longDescription = ''
      Usage: Add "zed-wakatime-ls" to programs.zed-editor.extraPackages in home-manager or globally
      in home.packages or environment.systemPackages to allow the Zed WakaTime extension to find and
      run the language server.
    '';
    homepage = "https://github.com/wakatime/zed-wakatime";
    changelog = "https://github.com/wakatime/zed-wakatime/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krishnans2006 ];
    mainProgram = "wakatime-ls";
  };
})
