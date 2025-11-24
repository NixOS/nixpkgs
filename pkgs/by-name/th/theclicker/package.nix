{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "theclicker";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "konkitoman";
    repo = "autoclicker";
    tag = finalAttrs.version;
    hash = "sha256-Q5Uwl2SWdat/cHRPf4GVQihn1NwlFKbkpWRFnScnvw0=";
  };

  cargoHash = "sha256-JL/X2s/SnmK88btz/MmB6t8nKqUXks07+tWXc4trfLM=";

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
