{ stdenv, cmake
, version, src, patches ? [ ]
, hostPlatform
, ...
}:

stdenv.mkDerivation rec {
  name = "libmsgpack-${version}";

  inherit src patches;

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  crossAttrs = {
  } // stdenv.lib.optionalAttrs (hostPlatform.libc == "msvcrt") {
    cmakeFlags = [
      "-DMSGPACK_BUILD_EXAMPLES=OFF"
      "-DCMAKE_SYSTEM_NAME=Windows"
    ];
  };

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage    = http://msgpack.org;
    license     = licenses.asl20;
    maintainers = with maintainers; [ redbaron wkennington ];
    platforms   = platforms.all;
  };
}
