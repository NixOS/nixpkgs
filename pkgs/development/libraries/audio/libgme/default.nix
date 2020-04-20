{ stdenv, fetchFromBitbucket, cmake }:
let
  version = "0.6.3";
in stdenv.mkDerivation {
  pname = "libgme";
  inherit version;

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
    sha256 = "100ahb4n4pvgcry9xzlf2fr4j57n5h9x7pvyhhxys4dcy8axqqsy";
  };

  buildInputs = [ cmake ];
}
