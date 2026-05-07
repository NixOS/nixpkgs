{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unused";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "unused-code";
    repo = "unused";
    rev = finalAttrs.version;
    sha256 = "sha256-+1M8dUfjjrT4llS0C6WYDyNxJ9QZ5s9v+W185TbgwMw=";
  };

  nativeBuildInputs = [ cmake ];

  cargoHash = "sha256-YOTTwkmYLU9+7FHw3EhIWFK2oDOwm+pGqCAqa4Ywuew=";

  meta = {
    description = "Tool to identify potentially unused code";
    homepage = "https://unused.codes";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
