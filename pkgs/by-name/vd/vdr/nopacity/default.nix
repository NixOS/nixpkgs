{
  stdenv,
  lib,
  fetchFromGitLab,
  vdr,
  graphicsmagick,
}:
stdenv.mkDerivation rec {
  pname = "vdr-skin-nopacity";
  version = "1.2.2";

  src = fetchFromGitLab {
    repo = "SkinNopacity";
    owner = "kamel5";
    hash = "sha256-XkuppNH95dJB6ATQumzT/YtoYN/k7fhnveX/diPrZGg=";
    tag = version;
  };

  buildInputs = [
    vdr
    graphicsmagick
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = {
    inherit (src.meta) homepage;
    description = "Highly customizable native true color skin for the Video Disc Recorder";
    maintainers = [ lib.maintainers.ck3d ];
    license = lib.licenses.gpl2;
    inherit (vdr.meta) platforms;
  };
}
