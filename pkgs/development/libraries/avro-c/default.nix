{ lib, stdenv, cmake, fetchurl, pkg-config, jansson, snappy, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "avro-c";
  version = "1.11.1";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "sha256-EliMTjED5/RKHgWrWD8d0Era9qEKov1z4cz1kEVTX5I=";
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
