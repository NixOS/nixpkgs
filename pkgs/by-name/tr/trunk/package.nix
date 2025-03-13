{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.8";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-iuJpxLNdJCPFr5v0bXipOr9KzQM/JeUBQQ7qyMaQsoA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-fTKzfsmWX8AS3GPOfkRAfdVIj2q1orI1j2tfo8AAsXU=";

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
