{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec{
  name = "zimg-${version}";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo  = "zimg";
    rev    = "9cbe9b0de66a690bdd142bae0e656e27c1f50ade";
    sha256 = "1qj5fr8ghgnyfjzdvgkvplicqsgyp05g3pvsdrg9yivvx32291hp";
  };

  buildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage = https://github.com/sekrit-twc/zimg;
    license  = licenses.wtfpl;
    platforms = platforms.linux; # check upstream issue #52
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
