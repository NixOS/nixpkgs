{ lib, stdenv, src, version
, autoreconfHook, pkg-config, protobuf, zlib
, ...
}:

stdenv.mkDerivation {
  pname = "protobuf-c";
  inherit version;

  inherit src;

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ protobuf zlib ];

  meta = with lib; {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
