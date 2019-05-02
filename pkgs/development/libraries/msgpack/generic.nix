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
    ;

  meta = with stdenv.lib; {
    description = "MessagePack implementation for C and C++";
    homepage    = https://msgpack.org;
    license     = licenses.asl20;
    maintainers = with maintainers; [ redbaron ];
    platforms   = platforms.all;
  };
}
