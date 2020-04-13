{ stdenv, version, fetch, cmake, fetchpatch, enableShared ? true }:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "1wb02ha3gl6p0a321hwpll74pz5qvjr11xmjqx62g288f1m10njk";

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = stdenv.lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
