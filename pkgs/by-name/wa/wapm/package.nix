{
  lib,
  fetchFromGitHub,
  perl,
  libiconv,
  openssl,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "wapm-cli";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wapm-cli";
    rev = "v${version}";
    hash = "sha256-T7YEe8xg5iwI/npisW0m+6FLi+eaAQVgYNe6TvMlhAs=";
  };

  cargoHash = "sha256-GW5/1/RsS5jn6DoR+wGpwNzUW+nN45cxpE85XbnXqso=";

  nativeBuildInputs = [ perl ];

  buildInputs = [
    libiconv
    openssl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Package manager for WebAssembly modules";
    mainProgram = "wapm";
    homepage = "https://docs.wasmer.io/ecosystem/wapm";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lucperkins ];
  };
}
