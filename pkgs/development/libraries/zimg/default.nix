{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec{
  name = "zimg-${version}";
  version = "2.8";

  src = fetchFromGitHub {
    owner  = "sekrit-twc";
    repo   = "zimg";
    rev    = "release-${version}";
    sha256 = "0s4n1swg1hgv81l8hvf0ny0fn305vf6l6dakbj452304p6ihxd83";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage    = https://github.com/sekrit-twc/zimg;
    license     = licenses.wtfpl;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
