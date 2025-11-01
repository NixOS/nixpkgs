{
  lib,
  fetchFromGitHub,
  callPackage,
  versionCheckHook,
  rustPlatform,
  pkg-config,
  zstd,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wild";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "davidlattimore";
    repo = "wild";
    tag = finalAttrs.version;
    hash = "sha256-hSHX0JjbG8rxw4FvvXb0sR6ftOHB2IVxoPVs0Kl9SVQ=";
  };

  cargoHash = "sha256-8l4cRnl2Nop+tTCoRv/Ke/SYJk9dxVMSak1hNuYecT4=";

  cargoBuildFlags = [ "-p wild-linker" ];

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    zstd
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  doCheck = false; # Tests are ran in passthru tests

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };

    tests = callPackage ./adapterTest.nix { wild = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Very fast linker for Linux";
    homepage = "https://github.com/davidlattimore/wild";
    changelog = "https://github.com/davidlattimore/wild/blob/${finalAttrs.version}/CHANGELOG.md";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    mainProgram = "wild";
    maintainers = with lib.maintainers; [ RossSmyth ];
    platforms = lib.platforms.linux;
  };
})
