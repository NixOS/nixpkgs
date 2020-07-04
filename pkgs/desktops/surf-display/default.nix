{ stdenv, fetchgit, makeWrapper
, surf, wmctrl, matchbox, xdotool, unclutter
, xorg, pulseaudio, xprintidle-ng }:

stdenv.mkDerivation rec {
  pname = "surf-display";
  version = "unstable-2019-04-15";

  src = fetchgit {
    url = "https://code.it-zukunft-schule.de/cgit/surf-display";
    rev = "972d6c4b7c4503dbb63fa6c92cdc24d1e32064a4";
    sha256 = "03c68gg4kfmkri1gn5b7m1g8vh9ciawhajb29c17kkc7mn388hjm";
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
       --prefix PATH ':' ${stdenv.lib.makeBinPath buildInputs}
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru = {
    providedSessions = [ "surf-display" ];
  };

  meta = with stdenv.lib; {
    description = "Kiosk browser session manager based on the surf browser";
    homepage = "https://code.it-zukunft-schule.de/cgit/surf-display/";
    maintainers = with maintainers; [ etu ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
