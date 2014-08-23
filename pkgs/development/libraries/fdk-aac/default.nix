{ stdenv, fetchurl }:

let version = "0.1.3";
in
stdenv.mkDerivation {
  name = "fdk-aac-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/fdk-aac-${version}.tar.gz";
    sha256 = "138c1l6c571289czihk0vlcfbla7qlac2jd5yyps5dyg08l8gjx9";
  };

  meta = with stdenv.lib; {
    description = "A high-quality implementation of the AAC codec from Android";
    homepage = "http://sourceforge.net/projects/opencore-amr/";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
