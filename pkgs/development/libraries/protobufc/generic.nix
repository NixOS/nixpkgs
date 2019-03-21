{ stdenv, src, version
, autoreconfHook, pkgconfig, protobuf, zlib
, ...
}:

stdenv.mkDerivation rec {
  name = "protobuf-c-${version}";

  inherit src;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ protobuf zlib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/protobuf-c/protobuf-c/;
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
