{
  lib,
  stdenv,
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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "wild-linker";
    repo = "wild";
    tag = finalAttrs.version;
    hash = "sha256-2E5W7UmWi9nBoWobZtZ5Td+0qaFSC7gKeF2t8yuZFK4=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-QqSKVBus3D/JkzhxudTtlcQFsY+KQPdWAbnCcf0L2pY=";

  cargoBuildFlags = [
    "-p"
    "wild-linker"
  ];

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    zstd
  ];

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  doCheck = false; # Tests are ran in passthru tests
  checkFlags = [
    "--skip=wasm/"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # https://github.com/davidlattimore/wild/discussions/832#discussioncomment-14482948
    "--skip=integration_test::program_name_71___unresolved_symbols_object_c__"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };

    tests = callPackage ./adapterTest.nix { wild-unwrapped = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Very fast linker for Linux";
    homepage = "https://github.com/wild-linker/wild";
    changelog = "https://github.com/wild-linker/wild/blob/${finalAttrs.version}/CHANGELOG.md";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    mainProgram = "wild";
    maintainers = with lib.maintainers; [ RossSmyth ];
    # Wild can run on Linux and Darwin, but can only target ELF platforms.
    # On linux this is native, on Darwin this is cross (or emulated)
    platforms = with lib.platforms; lib.optionals (stdenv.targetPlatform.isElf) (linux ++ darwin);
  };
})
