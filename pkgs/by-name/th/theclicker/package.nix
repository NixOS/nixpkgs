{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "theclicker";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "konkitoman";
    repo = "autoclicker";
    tag = finalAttrs.version;
    hash = "sha256-Bro7zpEDxkkvgNDhZEKLjogRD16Y3xtvG/TH1mqL8do=";
  };

  cargoHash = "sha256-l96yC/0ibapTjcJIvNtV28VqcUNUC+PrmEqvhtxwPHQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/konkitoman/autoclicker";
    description = "A simple autoclicker cli that works on (x11/wayland)";
    maintainers = [ lib.maintainers.SchweGELBin ];
    mainProgram = "theclicker";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
