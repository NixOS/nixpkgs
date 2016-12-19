{ stdenv, cmake
, version, src, patches ? [ ]
, ...
}:

stdenv.mkDerivation rec {
  name = "libmsgpack-${version}";

  inherit src patches;

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage = http://msgpack.org;
    maintainers = with maintainers; [ redbaron wkennington ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
