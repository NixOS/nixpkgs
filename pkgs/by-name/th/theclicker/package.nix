{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "theclicker";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "konkitoman";
    repo = "autoclicker";
    tag = finalAttrs.version;
    hash = "sha256-KhPSsLb5lg93WOI2JAbwSsM6x0A7t4ZNq2yGYg1Sqy0=";
  };

  cargoHash = "sha256-H0S1nP7EaNEougscmmelsY5CC7yHwXGhHGkY4vOZqho=";

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
