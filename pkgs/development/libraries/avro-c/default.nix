{ lib, stdenv, cmake, fetchurl, pkg-config, jansson, snappy, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "avro-c";
  version = "1.11.2";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "sha256-nx+ZqXsmcS0tQ/5+ck8Z19vdXO81R4uuRqGSDfIEV/U=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ jansson snappy xz zlib ];

  meta = with lib; {
    description = "A C library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.all;
  };
}
