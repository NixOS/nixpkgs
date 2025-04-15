{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.13";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-Kj0XUO8GSLBUwkvskOidA489cvcHdf9IKSVZ/OqlAnE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-oXLB/Jbb/J8oXl0IyECIjjv4pdKz94pocD/iTBv4GRs=";

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
