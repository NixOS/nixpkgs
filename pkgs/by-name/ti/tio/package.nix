{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  inih,
  lua,
  bash-completion,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tio";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "tio";
    repo = "tio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-92+F41kDGKgzV0e7Z6xly1NRDm8Ayg9eqeKN+05B4ok=";
  };

  strictDeps = true;

  buildInputs = [
    inih
    lua
    glib
    bash-completion
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = {
    description = "Serial console TTY";
    homepage = "https://tio.github.io/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "tio";
    platforms = lib.platforms.unix;
  };
})
