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
  version = "0-unstable-2024-04-19";

  src = fetchFromGitHub {
    owner = "gabrielzschmitz";
    repo = "Tomato.C";
    rev = "b3b85764362a7c120f3312f5b618102a4eac9f01";
    hash = "sha256-7i+vn1dAK+bAGpBlKTnSBUpyJyRiPc7AiUF/tz+RyTI=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "sudo " ""
    substituteInPlace notify.c \
      --replace-fail "/usr/local" "${placeholder "out"}"
    substituteInPlace util.c \
      --replace-fail "/usr/local" "${placeholder "out"}"
    substituteInPlace tomato.desktop \
      --replace-fail "/usr/local" "${placeholder "out"}"
  '';

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
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tomato";
    platforms = lib.platforms.unix;
  };
})
