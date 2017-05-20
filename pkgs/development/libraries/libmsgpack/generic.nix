{ stdenv, cmake
, version, src, patches ? [ ]
, ...
}:

stdenv.mkDerivation rec {
  name = "libmsgpack-${version}";

  inherit src patches;

  nativeBuildInputs = [ cmake ];

  crossAttrs = {
  } // stdenv.lib.optionalAttrs (stdenv.cross.libc == "msvcrt") {
    cmakeFlags = "-DMSGPACK_BUILD_EXAMPLES=OFF -DCMAKE_SYSTEM_NAME=Windows";
  };

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage = http://msgpack.org;
    maintainers = with maintainers; [ redbaron wkennington ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
