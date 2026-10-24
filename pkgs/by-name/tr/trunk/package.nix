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
  wasm-bindgen-cli_0_2_129,
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

  cargoPatches = [
    ./update-libdeflate-gcc-16.patch # https://github.com/NixOS/nixpkgs/issues/569854
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-8HwfZ9dyplxc405rM33uNnjNt5JBFGWcmDNZJGMha9s=";

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
          # This version is a fallback choice, not a requirement imposed by trunk.
          # No exact match for the version trunk downloads was available in nixpkgs,
          # so the closest available version was chosen.
          wasm-bindgen-cli_0_2_129
          # tailwindcss-extra # not in nixpkgs
        ]
      }"
  '';

  meta = {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with lib.maintainers; [ ctron ];
    license = lib.licenses.asl20;
  };
})
