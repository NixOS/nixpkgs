{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vivid";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "vivid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5SRZq2L49Kn6zwK1DXjtakz2zKrcAdbMdQ0yxykUvm8=";
  };

  cargoHash = "sha256-RM6OY5TLofKZPsWoNnF4ZPGhF9eV+ZmOuGXe7Xjc254=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "vivid";
  };
})
