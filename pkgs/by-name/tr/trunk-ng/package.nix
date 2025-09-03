{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk-ng";
  version = "0.17.16";

  src = fetchFromGitHub {
    owner = "ctron";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-SnE0z9Wa4gtX/ts0vG9pYnnxumILHTSV9/tVYkCHFck=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    if stdenv.hostPlatform.isDarwin then
      [
        libiconv
      ]
    else
      [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-jDewjDm7Nh09CkRdPG0/ELn4odz/aaRNg8GegDxK6f8=";

  meta = with lib; {
    homepage = "https://github.com/ctron/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk-ng";
    maintainers = with maintainers; [ ctron ];
    license = with licenses; [ asl20 ];
  };
}
