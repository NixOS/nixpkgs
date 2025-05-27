{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeekstd";
  version = "0.4.0-lib";

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+WOTMZwsTTkwgSCP1IOPTo/dl6ceC7Jg6bMT8kNrRwI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iAj3QxJbclh7yhI4A0WmxcnZGy4p/3C5G3z+HelJr7g=";

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
})
