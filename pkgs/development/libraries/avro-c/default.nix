{ stdenv, bash, cmake, fetchurl, pkgconfig, jansson, zlib }:

let
  version = "1.8.2";
in stdenv.mkDerivation rec {
  name = "avro-c-${version}";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "03pixl345kkpn1jds03rpdcwjabi41rgdzi8f7y93gcg5cmrhfa6";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ jansson zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A C library which implements parts of the Avro Specification";
    homepage = https://avro.apache.org/;
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.all;
  };
}
