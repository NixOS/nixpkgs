{ stdenv, fetchFromBitbucket, cmake }:
let
  version = "0.6.1";
in stdenv.mkDerivation {
  name = "libgme-${version}";

  meta = with stdenv.lib; {
    description = "A collection of video game music chip emulators";
    homepage = "https://bitbucket.org/mpyne/game-music-emu/overview";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ lheckemann ];
  };

  src = fetchFromBitbucket {
    owner = "mpyne";
    repo = "game-music-emu";
    rev = version;
    sha256 = "04vwpv3pmjcil1jw5vcnlg45nch5awqs06y3xqdlp3ibx5i4k199";
  };

  buildInputs = [ cmake ];
}
