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

  cmakeFlags = {}
    // stdenv.lib.optionalAttrs (stdenv.hostPlatform != stdenv.buildPlatform) {
    MSGPACK_BUILD_EXAMPLES = false;
  } // stdenv.lib.optionalAttrs (hostPlatform.libc == "msvcrt") {
    CMAKE_SYSTEM_NAME = "Windows";
  };

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage    = https://msgpack.org;
    license     = licenses.asl20;
    maintainers = with maintainers; [ redbaron wkennington ];
    platforms   = platforms.all;
  };
}
