{ stdenv, cmake
, version, src, patches ? [ ]
, ...
}:

stdenv.mkDerivation rec {
  name = "msgpack-${version}";

  inherit src patches;

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = []
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
                           "-DMSGPACK_BUILD_EXAMPLES=OFF"
    ++ stdenv.lib.optional (stdenv.hostPlatform.libc == "msvcrt")
                           "-DCMAKE_SYSTEM_NAME=Windows"
    ;

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage    = https://msgpack.org;
    license     = licenses.asl20;
    maintainers = with maintainers; [ redbaron wkennington ];
    platforms   = platforms.all;
  };
}
