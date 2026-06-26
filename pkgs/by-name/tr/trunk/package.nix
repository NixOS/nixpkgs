{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  makeWrapper,
  binaryen,
  dart-sass,
  tailwindcss,
  wasm-bindgen-cli_0_2_108,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "trunk";
  version = "0.21.14";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0T8ZkBA1Zf4z2HXYeBwJ+2EGoUpxGrqSb4fS4CnL28A=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-/5zvbSlMzZHxnAwuu0Jd6WVVjxJtIAQpRwZZHgYyPbs=";

  # Add programs used in trunk to PATH.
  # When trunk fails to find these paths, it fetches prebuilt binaries
  # which don't work on NixOS.  These are added to the suffix so the
  # user can easily override them.
  postInstall = ''
    wrapProgram $out/bin/trunk \
      --suffix PATH : "${
        lib.makeBinPath [
          binaryen
          dart-sass
          tailwindcss
          wasm-bindgen-cli_0_2_108
          # tailwindcss-extra # not in nixpkgs
        ]
      }"
  '';

  meta = {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with lib.maintainers; [ ctron ];
    license = with lib.licenses; [ asl20 ];
  };
})
