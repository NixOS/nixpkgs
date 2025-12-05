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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "davidlattimore";
    repo = "wild";
    tag = finalAttrs.version;
    hash = "sha256-x0IZuWjj0LRMj4pu2FVaD8SENm/UVtE1e4rl0EOZZZM=";
  };

  cargoHash = "sha256-5s0qS8y0+EH+R1tgN2W5/+t+GdjbQdRVLlcA2KjpHsE=";

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
