{ stdenv, fetchFromBitbucket, cmake }:
let
  version = "0.6.1";
in stdenv.mkDerivation {
  name = "libgme-${version}";

  src = fetchFromBitbucket {
    owner = "mpyne";
    repo = "game-music-emu";
    rev = version;
    sha256 = "04vwpv3pmjcil1jw5vcnlg45nch5awqs06y3xqdlp3ibx5i4k199";
  };

  buildInputs = [ cmake ];
}
