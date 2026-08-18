{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tenki";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "tenki";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kvGlysdm7vw5yvcH7MZCk0Gm9bEfpqf0wF4QJUvU48E=";
  };

  cargoHash = "sha256-e8ZFQ2CUgkHOGn5yH6/P/s4aI0wlFzvJRgzHQUDuw4Y=";

  meta = {
    description = "tty-clock with weather effect";
    homepage = "https://github.com/ckaznable/tenki";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "tenki";
  };
})
