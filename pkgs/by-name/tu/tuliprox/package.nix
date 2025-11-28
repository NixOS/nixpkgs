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
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuliprox";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "euzu";
    repo = "tuliprox";
    tag = "v${version}";
    hash = "sha256-G+bVKBAxviyJShq2BG4vjMiTzHhoYaiP6FXrSWeTvkU=";
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

  cargoHash = "sha256-bDQ4pDDTINTgotTen1/SxOZBmkUmbmmwmR4/nSoSf/A=";

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

  passthru = {
    tests = { inherit (nixosTests) tuliprox; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Flexible IPTV playlist processor & proxy in Rust";
    homepage = "https://github.com/euzu/tuliprox";
    changelog = "https://github.com/euzu/tuliprox/blob/${src.tag}/CHANGELOG.md";
    mainProgram = "tuliprox";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
