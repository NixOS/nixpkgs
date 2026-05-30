{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "todo";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "sioodmy";
    repo = "todo";
    rev = finalAttrs.version;
    sha256 = "oyRdXvVnCfdFM8lI1eCDHHYNWcJc0Qg0TKxQXUqNo40=";
  };

  cargoHash = "sha256-mRLTQYkKXxhcwI2Ra/HCkxejDl3nnraJw+VCqRgCUig=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
  meta = {
    description = "Simple todo cli program written in rust";
    homepage = "https://github.com/sioodmy/todo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sioodmy ];
    mainProgram = "todo";
  };
})
