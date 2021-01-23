{ lib, stdenv, version, fetch, cmake, fetchpatch
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "libunwind";
  inherit version;

  src = fetch pname "0zsixkaiwp007afxlpsf5dc7wfrv8sj9wxzjw6f1r4bjv1rv3cvd";

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (!enableShared) "-DLIBUNWIND_ENABLE_SHARED=OFF";
}
