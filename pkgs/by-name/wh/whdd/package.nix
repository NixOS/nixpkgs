{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  ncurses,
  dialog,
  coreutils,
  gawk,
  gnugrep,
  smartmontools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whdd";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "whdd";
    repo = "whdd";
    tag = "${finalAttrs.version}";
    hash = "sha256-cwaWI3dvjaOgBRlJcxioFb9Xjdv45XmQ71EgCvuArdo=";
  };

  buildInputs = [
    dialog
    ncurses
  ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/whdd \
      --prefix PATH : ${
        lib.makeBinPath [
          smartmontools
          gnugrep
          gawk
          coreutils
        ]
      }
  '';

  meta = {
    homepage = "https://whdd.github.io/";
    description = "HDD diagnostic and data recovery tool for Linux";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "whdd";
    maintainers = [ lib.maintainers.hehongbo ];
  };
})
