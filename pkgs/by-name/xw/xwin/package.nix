{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xwin";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "Jake-Shadle";
    repo = "xwin";
    tag = finalAttrs.version;
    hash = "sha256-bow/TJ6aIXoNZDqCTlQYAMxEUiolby1axsKiLMk/jiA=";
  };

  cargoHash = "sha256-S/3EjlG0Dr/KKAYSFaX/aFh/CIc19Bv+rKYzKPWC+MI=";

  # The check tests whether the header download succeeds
  # The sandbox prohibits network access
  doCheck = false;

  meta = {
    description = "Provide headers to link against msvc windows libs";
    mainProgram = "xwin";
    homepage = "https://github.com/Jake-Shadle/xwin";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ greaka ];
  };
})
