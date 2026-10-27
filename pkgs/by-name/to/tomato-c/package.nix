{
  lib,
  stdenv,
  fetchFromGitHub,
  libnotify,
  makeWrapper,
  mpv,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomato-c";
  version = "0-unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "gabrielzschmitz";
    repo = "Tomato.C";
    rev = "590224cbbf0f53f09d33080c4e83797a11ad02d1";
    hash = "sha256-TVvCqWWjfFHcFOMEO9frfrs9638cOjkV8yvqavdzdmI=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libnotify
    mpv
    ncurses
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installFlags = [
    "CPPFLAGS=$NIX_CFLAGS_COMPILE"
    "LDFLAGS=$NIX_LDFLAGS"
  ];

  postFixup = ''
    for file in $out/bin/*; do
      wrapProgram $file \
        --prefix PATH : ${
          lib.makeBinPath [
            libnotify
            mpv
          ]
        }
    done
  '';

  strictDeps = true;

  meta = {
    homepage = "https://github.com/gabrielzschmitz/Tomato.C";
    description = "Pomodoro timer written in pure C";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "tomato";
    platforms = lib.platforms.unix;
  };
})
