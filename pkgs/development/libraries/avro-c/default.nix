{ lib, stdenv, cmake, fetchurl, pkg-config, jansson, zlib }:

stdenv.mkDerivation rec {
  pname = "avro-c";
  version = "1.11.0";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "sha256-BlJZClStjkqliiuf8fTOcaZKQbCgXEUp0cUYxh52BkM=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ jansson zlib ];

  meta = with lib; {
    description = "A C library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.all;
  };
}
