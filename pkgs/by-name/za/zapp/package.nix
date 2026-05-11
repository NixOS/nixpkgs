{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zapp";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "zapp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0gf1famCPfsShYyankk9/Y/aA8/XbCbOJVmdNl416jk=";
  };

  cargoHash = "sha256-0jmYOfuAfmq8vJvWww6WHjt1J5nRbDDFNFi/vN5ANk8=";

  meta = {
    description = "A cross-platform CLI tool for flashing ZSA keyboards";
    homepage = "https://github.com/zsa/zapp";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ linusdikomey ];
    mainProgram = "zapp";
    platforms = lib.platforms.all;
  };
})
