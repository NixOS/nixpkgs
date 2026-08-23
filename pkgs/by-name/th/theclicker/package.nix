{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "theclicker";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "konkitoman";
    repo = "autoclicker";
    tag = finalAttrs.version;
    hash = "sha256-iD9v0HY/2Q0oeUmJwyfXNuEsmIJDV2M+dzpJ1z6TaF0=";
  };

  cargoHash = "sha256-YdeAG6+p/8MzvqEAyfzGktmnxw7hGvV/gGFg6uMwD5A=";

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
