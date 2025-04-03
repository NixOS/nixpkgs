{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.9";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-+HKEaXdGW3F5DCvyvQalr65+BZv+NA2r34MSvPwlhac=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-xaL7gF9gWRn0geKIUwksDovaIHMqfl57O9GvHOjgsic=";

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
