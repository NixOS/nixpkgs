{ stdenv, version, fetch, cmake, fetchpatch, enableShared ? true }:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "1rxfwmdx1wl53id0c3f7a6hmzc2wlz6x85yqg2qi9q0c40yngfsy";

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = stdenv.lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
