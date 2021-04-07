{ lib, stdenv, fetchurl
, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libast";
  version = "0.7.1";

  src = fetchurl {
    url = "http://www.eterm.org/download/${pname}-${version}.tar.gz";
    sha256 = "1w7bs46r4lykfd83kc3bg9i1rxzzlb4ydk23ikf8mx8avz05q1aj";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Library of Assorted Spiffy Things";
    homepage = "https://www.eterm.org";
    license = licenses.bsd2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
