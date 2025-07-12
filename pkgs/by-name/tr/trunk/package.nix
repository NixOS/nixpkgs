{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  makeBinaryWrapper,
  binaryen,
  dart-sass,
  tailwindcss,
  wasm-bindgen-cli_0_2_92,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.14";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-0T8ZkBA1Zf4z2HXYeBwJ+2EGoUpxGrqSb4fS4CnL28A=";
  };

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  useFetchCargoVendor = true;
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
          wasm-bindgen-cli_0_2_92
          # tailwindcss-extra # not in nixpkgs
        ]
      }"
  '';

  meta = with lib; {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with maintainers; [
      freezeboy
      ctron
    ];
    license = with licenses; [ asl20 ];
  };
}
