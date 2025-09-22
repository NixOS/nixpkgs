{
  lib,
  stdenv,
  fetchurl,
  libpulseaudio,
  alsa-lib,
  pkg-config,
  qt5,
  ncurses,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unixcw";
  version = "3.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/unixcw/unixcw-${finalAttrs.version}.tar.gz";
    hash = "sha256-Cvg4VSFL+QtMDRSSIYhKtEWPOFfDiXLUKNrr87rdbjI=";
  };

  patches = [
    # fix pkg-config searching for ncurses
    # yoinked from gentoo (https://gitweb.gentoo.org/repo/gentoo.git/tree/media-radio/unixcw/files/unixcw-3.6-tinfo.patch), with modifications
    ./unixcw-3.6-tinfo.patch
  ];

  postPatch = ''
    substituteInPlace src/cwcp/Makefile.am \
      --replace-fail '-lcurses' '-lncurses'
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libpulseaudio
    alsa-lib
    qt5.qtbase
    ncurses
  ];

  CFLAGS = "-lasound -lpulse-simple";

  meta = {
    description = "Sound characters as Morse code on the soundcard or console speaker";
    longDescription = ''
      unixcw is a project providing libcw library and a set of programs
      using the library: cw, cwgen, cwcp and xcwcp.
      The programs are intended for people who want to learn receiving
      and sending Morse code.
      unixcw is developed and tested primarily on GNU/Linux system.

      cw  reads  characters  from  an input file, or from standard input,
      and sounds each valid character as Morse code on either the system sound card,
      or the system console speaker.
      After it sounds a  character, cw  echoes it to standard output.
      The input stream can contain embedded command strings.
      These change the parameters used when sounding the Morse code.
      cw reports any errors in  embedded  commands
    '';
    homepage = "https://unixcw.sourceforge.net";
    maintainers = [ lib.maintainers.mafo ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
