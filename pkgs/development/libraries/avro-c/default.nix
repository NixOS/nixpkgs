{ stdenv, bash, cmake, fetchurl, pkgconfig, jansson, zlib }:

let version = "1.8.2"; in

stdenv.mkDerivation rec {
  name = "avro-c-${version}";

  #
  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "03pixl345kkpn1jds03rpdcwjabi41rgdzi8f7y93gcg5cmrhfa6";
  };

  patchPhase = ''
    substituteInPlace version.sh \
      --replace /bin/bash "$bash/bin/bash"
  '';

  buildInputs = [
    pkgconfig
    cmake
    jansson
    zlib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A C library which implements parts of the Avro Specification";
    homepage = https://avro.apache.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ lblasc ];
    platforms = stdenv.lib.platforms.all;
  };
}
