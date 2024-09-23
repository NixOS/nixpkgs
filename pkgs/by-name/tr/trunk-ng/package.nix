{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security, SystemConfiguration }:

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
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security SystemConfiguration ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = {
    darwin = "sha256-TwpGw3LH3TmZSbC4DkoOYpQdOpksXXoAoiacyZAefTU=";
    linux = "sha256-AivISmT/r8xa/vSXUN8sU7z67t1hcyMQM+t6oXmIOhU=";
  }.${stdenv.hostPlatform.parsed.kernel.name} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = with lib; {
    homepage = "https://github.com/ctron/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk-ng";
    maintainers = with maintainers; [ ctron ];
    license = with licenses; [ asl20 ];
  };
}
