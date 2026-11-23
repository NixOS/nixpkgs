{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  ffmpeg,
  which,
  rustc,
  wasm-bindgen-cli_0_2_114,
  trunk,
  binaryen,
  cacert,
  dart-sass,
  nixosTests,
  nix-update-script,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuliprox";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "euzu";
    repo = "tuliprox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0dVTW1PdN9wesbnN6sbB16328b0rYLhmmnqiov2lK3w=";
  };

  nativeBuildInputs = [
    pkg-config
    ffmpeg
    which
    wasm-bindgen-cli_0_2_114
    trunk
    rustc.llvmPackages.lld
    binaryen
    dart-sass
  ];

  buildInputs = [ zstd ];

  # Needed to get openssl-sys to use pkg-config.
  env = {
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  cargoHash = "sha256-Rgp8yM13XcGVvqvr2jf5eQnfX1jldr6MFfZZ19cGzxE=";

  cargoBuildFlags = "--package tuliprox";

  postBuild = ''
    patchShebangs ./bin/build_resources.sh
    ./bin/build_resources.sh
    pushd frontend
    trunk build --offline --frozen --release
    popd
  '';

  # reqwest needs CA certificates to build its clients
  nativeCheckInputs = [ cacert ];

  # Tests bind to and connect to localhost
  __darwinAllowLocalNetworking = true;

  postInstall = ''
    cp -rf frontend/dist $out/web
    mkdir -p $out/resources
    cp -rf resources/*.ts $out/resources
  '';

  passthru = {
    tests = { inherit (nixosTests) tuliprox; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Flexible IPTV playlist processor & proxy in Rust";
    homepage = "https://github.com/euzu/tuliprox";
    changelog = "https://github.com/euzu/tuliprox/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "tuliprox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
})
