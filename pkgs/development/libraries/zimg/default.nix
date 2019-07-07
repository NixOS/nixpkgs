{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "zimg";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner  = "sekrit-twc";
    repo   = "zimg";
    rev    = "release-${version}";
    sha256 = "0q9migrxyp5wc6lcl6gnfs1zwn1ncqna6cm7vz3c993vvmgdf1p9";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage    = https://github.com/sekrit-twc/zimg;
    license     = licenses.wtfpl;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
