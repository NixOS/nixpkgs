{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec{
  name = "zimg-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo  = "zimg";
    rev    = "e88b156fdd6d5ae647bfc68a30e86d14f214764d";
    sha256 = "1hb35pm9ykdyhg71drd59yy29d154m2r1mr8ikyzpi3knanjn23a";
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
