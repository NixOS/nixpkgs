{
  lib,
  stdenv,
  fetchgit,
  makeWrapper,
  surf,
  wmctrl,
  matchbox,
  xdotool,
  unclutter,
  xorg,
  pulseaudio,
  xprintidle-ng,
}:

stdenv.mkDerivation rec {
  pname = "surf-display";
  version = "unstable-2022-10-07";

  src = fetchgit {
    url = "https://code.it-zukunft-schule.de/cgit/surf-display";
    rev = "ad0bd30642f8334d42bb08ea5c1b9dd03fccc4d1";
    hash = "sha256-wiyFh1te3afASIODn0cA5QXcqnrP/8Bk6hBAZYbKJQQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    surf
    wmctrl
    matchbox
    pulseaudio
    xprintidle-ng
    xdotool
    xorg.xmodmap
    xorg.xkbutils
    unclutter
  ];

  patches = [ ./pdf-makefile.patch ];

  buildFlags = [ "man" ];

  postFixup = ''
    substituteInPlace $out/share/xsessions/surf-display.desktop \
      --replace surf-display $out/bin/surf-display

    substituteInPlace $out/bin/surf-display --replace /usr/share $out/share

    patchShebangs $out/bin/surf-display
    wrapProgram $out/bin/surf-display \
       --prefix PATH ':' ${lib.makeBinPath buildInputs}
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru = {
    providedSessions = [ "surf-display" ];
  };

  meta = with lib; {
    description = "Kiosk browser session manager based on the surf browser";
    mainProgram = "surf-display";
    homepage = "https://code.it-zukunft-schule.de/cgit/surf-display/";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
