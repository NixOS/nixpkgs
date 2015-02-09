{ stdenv, src, version
, autoreconfHook, pkgconfig, protobuf, zlib
, ...
}:

stdenv.mkDerivation rec {
  name = "protobuf-c-${version}";

  inherit src;

  buildInputs = [ autoreconfHook pkgconfig protobuf zlib ];

  meta = with stdenv.lib; {
    homepage = http://github.com/protobuf-c/protobuf-c/;
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
