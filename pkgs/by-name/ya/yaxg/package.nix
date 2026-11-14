{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  maim,
  slop,
  ffmpeg,
  byzanz,
  libnotify,
  xdpyinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yaxg";
  version = "0-unstable-2018-05-03";

  src = fetchFromGitHub {
    owner = "DanielFGray";
    repo = "yaxg";
    rev = "9d6af75da2ec25dba4b8d784e431064033d67ad2";
    hash = "sha256-5gYa0sN63yZOUBi8YA7sTXN8b6LrLXRqtjS7HS585gY=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    maim
    slop
    ffmpeg
    byzanz
    libnotify
    xdpyinfo
  ];

  installPhase = ''
    mkdir -p $out/bin/
    mv yaxg $out/bin/
    chmod +x $out/bin/yaxg
    wrapProgram $out/bin/yaxg --prefix PATH : ${
      lib.makeBinPath [
        maim
        slop
        ffmpeg
        byzanz
        libnotify
        xdpyinfo
      ]
    }
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Yet Another X Grabber script";
    longDescription = ''
      Capture and record your screen with callbacks. Wraps maim, slop, ffmpeg,
      and byzanz to enable still image, video, or gif recording of part or all
      of your screen. Similar command-line interface to scrot but is overall
      more flexible and less buggy.
    '';
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    mainProgram = "yaxg";
  };
})
