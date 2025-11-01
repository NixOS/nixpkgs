{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  ffmpeg,
  which,
  rustc,
  wasm-bindgen-cli_0_2_104,
  trunk,
  binaryen,
  dart-sass,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuliprox";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "euzu";
    repo = "tuliprox";
    tag = "v${version}";
    hash = "sha256-uqPdXMc5ZlFtB6LclJe6jLTZ2ClXpXEz6r4TkfFuX0A=";
  };

  nativeBuildInputs = [
    pkg-config
    ffmpeg
    which
    wasm-bindgen-cli_0_2_104
    trunk
    rustc.llvmPackages.lld
    binaryen
    dart-sass
  ];

  # Needed to get openssl-sys to use pkg-config.
  env = {
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  cargoHash = "sha256-bVnfSQ3dzT+Efic1+QVFFUc3iy+b7dS6xil1aE41fZQ=";

  cargoBuildFlags = "--package tuliprox";

  postBuild = ''
    patchShebangs ./bin/build_resources.sh
    ./bin/build_resources.sh
    pushd frontend
    trunk build --offline --frozen --release
    popd
  '';

  checkFlags = [
    "--skip=processing::parser::xmltv::tests::normalize"
    "--skip=processing::parser::xtream::tests::test_read_json_file_into_struct"
    "--skip=repository::indexed_document::tests::test_read_xt"
  ];

  postInstall = ''
    cp -rf frontend/dist $out/web
    mkdir -p $out/resources
    cp -rf resources/*.ts $out/resources
  '';

  passthru.tests = { inherit (nixosTests) tuliprox; };

  meta = {
    description = "Flexible IPTV playlist processor & proxy in Rust";
    homepage = "https://github.com/euzu/tuliprox";
    changelog = "https://github.com/euzu/tuliprox/blob/${src.tag}/CHANGELOG.md";
    mainProgram = "tuliprox";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
