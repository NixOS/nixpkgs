{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  pam,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "term39";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "alejandroqh";
    repo = "term39";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1O9YEA8p5unKbkQIxWSPc/suedUwFgzm03AhGTtmEGE=";
  };

  cargoHash = "sha256-mLvjCZ5O9MdA6rGs/fT85ate4BTAvdfHhTnbGPmr+vk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pam
  ];

  meta = {
    description = "A modern, retro-styled terminal multiplexer with a classic MS-DOS aesthetic";
    homepage = "https://github.com/alejandroqh/term39";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alejandroqh ];
    mainProgram = "term39";
    platforms = lib.platforms.linux;
  };
})
