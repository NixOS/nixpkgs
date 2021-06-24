{ lib, stdenv, version, fetch, cmake, fetchpatch
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "09syx66idnm2pr46x2vmk0jn3iwdv0lkd04xy4zjbwmz3vn066bl";

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
