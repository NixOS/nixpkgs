{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libomxil-bellagio";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/omxil/omxil/Bellagio%20${version}/${pname}-${version}.tar.gz";
    sha256 = "0k6p6h4npn8p1qlgq6z3jbfld6n1bqswzvxzndki937gr0lhfg2r";
  };

  configureFlags =
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "ac_cv_func_malloc_0_nonnull=yes" ];

  patches = [
    ./fedora-fixes.patch
    ./fno-common.patch
  ];

  # Disable parallel build as it fails as:
  #    ld: cannot find -lomxil-bellagio
  enableParallelBuilding = false;

  doCheck = false; # fails

  NIX_CFLAGS_COMPILE =
    if stdenv.cc.isGNU then "-Wno-error=array-bounds -Wno-error=stringop-overflow=8"
    else "-Wno-error=absolute-value -Wno-error=enum-conversion -Wno-error=logical-not-parentheses -Wno-error=non-literal-null-conversion";

  meta = with lib; {
    homepage = "https://omxil.sourceforge.net/";
    description = "An opensource implementation of the Khronos OpenMAX Integration Layer API to access multimedia components";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
