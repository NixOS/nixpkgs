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
  pname = "wild-unwrapped";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "davidlattimore";
    repo = "wild";
    tag = finalAttrs.version;
    hash = "sha256-E5cmZuOtF+MNTPyalKjnguhin70zqtDDB0D71ZpeE48=";
  };

  cargoHash = "sha256-r0r7sN1SW5TIybHORfzJkN51Y0REEC2/h7q71GxUgAM=";

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

  passthru = {
    updateScript = nix-update-script { };

    tests = callPackage ./adapterTest.nix { wild-unwrapped = finalAttrs.finalPackage; };
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
