{ stdenv, fetchFromBitbucket, cmake }:
let
  version = "0.6.2";
in stdenv.mkDerivation {
  pname = "libgme";
  inherit version;

  meta = with stdenv.lib; {
    description = "A collection of video game music chip emulators";
    homepage = https://bitbucket.org/mpyne/game-music-emu/overview;
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ lheckemann ];
  };

  src = fetchFromBitbucket {
    owner = "mpyne";
    repo = "game-music-emu";
    rev = version;
    sha256 = "00vlbfk5h99dq5rbwxk20dv72dig6wdwpgf83q451avsscky0jvk";
  };

  buildInputs = [ cmake ];
}
