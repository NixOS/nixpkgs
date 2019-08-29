{ stdenv, fetchurl
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libast-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "http://www.eterm.org/download/${name}.tar.gz";
    sha256 = "1w7bs46r4lykfd83kc3bg9i1rxzzlb4ydk23ikf8mx8avz05q1aj";
  };

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Library of Assorted Spiffy Things";
    homepage = https://www.eterm.org;
    license = licenses.bsd2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
