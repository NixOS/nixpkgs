{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  pkg-config,
  zstd,
  aws-lc,
  gitMinimal,
  cmake,
  libclang,
  boringssl,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmc-cli";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rage";
    repo = "tmc-cli-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Not6jDgMtGi5DngzyoClP29JvDsHdERsmZrFLcqiQGw=";
  };

  cargoHash = "sha256-9Gb0v7h6kHaPuC2wouLqwchgDbyljFWNCywEaDChSBI=";

  nativeBuildInputs = [
    pkg-config
    gitMinimal
    cmake
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    zstd
    aws-lc
    libclang.lib
    boringssl
  ];

  env = {
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
    BORING_BSSL_PATH = boringssl;
    BORING_BSSL_INCLUDE_PATH = "${lib.getDev boringssl}/include";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/boring-sys-*/build/main.rs $cargoDepsCopy/*/quiche-*/src/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=crypto" "cargo:rustc-link-lib=dylib=crypto" \
      --replace-fail "cargo:rustc-link-lib=static=ssl" "cargo:rustc-link-lib=dylib=ssl"
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    cacert
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # When sandboxing, "Attempted to create a NULL object."
    # https://github.com/mullvad/system-configuration-rs/pull/59 may fix.
    "--skip=commands::courses::tests::list_courses_with_client_test"
    # Same
    "--skip=all_integration_tests"
    # When sandboxing, "Lazy instance has previously been poisoned."
    "--skip=commands::exercises::tests::list_exercises_with_client_test"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI for using the TestMyCode programming assignment evaluator";
    homepage = "https://github.com/rage/tmc-cli-rust";
    changelog = "https://github.com/rage/tmc-cli-rust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hekazu ];
    mainProgram = "tmc";
  };
})
