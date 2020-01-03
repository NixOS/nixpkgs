{ stdenv, cmake, fetchurl, pkgconfig, jansson, zlib }:

let
  version = "1.9.1";
in stdenv.mkDerivation {
  pname = "avro-c";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "0hj6w1w5mqkhnhkvjc0zz5njnnrbcjv5ml4f8gq80wff2cgbrxvx";
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
