# This is a revival of the old trrntzip at
# https://sourceforge.net/projects/trrntzip
#
# See https://sourceforge.net/p/trrntzip/discussion/457469/thread/d3610ea3b6/
# there hasn't been any response
#
# Besides the new one is on github instead of sourceforge
# which makes life for us easier

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trrntzip";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "0-wiz-0";
    repo = "trrntzip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-whxPqXT6w91jWv9aoTE4ITbjqohgwytzA0HN7WXKcTA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Goal of the program is to use standard values when creating zips to create identical files over multiple systems";
    longDescription = ''
      Torrentzip converts zip archives to a standard format with some
      pre-defined values, sorting the files, and using particular compression
      settings so that running it on zip archives created by other tools will
      always result in the same output. This helps e.g. with sharing
      zip archives using BitTorrent (which is where the name comes from).

      This is a revival of https://sourceforge.net/projects/trrntzip.
    '';
    homepage = "https://github.com/0-wiz-0/trrntzip";
    license = with licenses; [
      # "This software includes code from minizip, which is part of zlib"
      licenses.zlib

      gpl2Plus
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
})
