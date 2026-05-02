{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  pam,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "term39";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "alejandroqh";
    repo = "term39";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IFJXBTjGedDl+FY7HDE5p+jYqA3c5EHHxQfn8hPY/es=";
  };

  cargoHash = "sha256-RguJr5xtuLcn4OO/8hmg06AmUT6WPzGtCpB0J+xw8+I=";

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
