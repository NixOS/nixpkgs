{ fetchurl, stdenv, zlib, protobuf }:

stdenv.mkDerivation rec {
  name = "protobuf-c-0.15";

  src = fetchurl {
    url = "http://protobuf-c.googlecode.com/files/${name}.tar.gz";
    sha256 = "0dh0180lzqk6n1r0qk38kgdy4x15mpkg5j4g2r31qhx52f757jwg";
  };

  buildInputs = [ protobuf ];

  doCheck = true;

  meta = {
    description = "C bindings for Google's Protocol Buffers";

    license = "BSD";

    homepage = http://code.google.com/p/protobuf-c/;
  };
}
