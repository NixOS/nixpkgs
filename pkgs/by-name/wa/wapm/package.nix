{
  lib,
  fetchFromGitHub,
  perl,
  libiconv,
  openssl,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wapm-cli";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wapm-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T7YEe8xg5iwI/npisW0m+6FLi+eaAQVgYNe6TvMlhAs=";
  };

  cargoHash = "sha256-GW5/1/RsS5jn6DoR+wGpwNzUW+nN45cxpE85XbnXqso=";

  nativeBuildInputs = [ perl ];

  buildInputs = [
    libiconv
    openssl
  ];

  doCheck = false;

  meta = {
    description = "Package manager for WebAssembly modules";
    mainProgram = "wapm";
    homepage = "https://docs.wasmer.io/ecosystem/wapm";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.lucperkins ];
  };
})
