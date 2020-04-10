{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libomxil-bellagio";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/omxil/omxil/Bellagio%20${version}/${pname}-${version}.tar.gz";
    sha256 = "0k6p6h4npn8p1qlgq6z3jbfld6n1bqswzvxzndki937gr0lhfg2r";
  };

  configureFlags =
    stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "ac_cv_func_malloc_0_nonnull=yes" ];

  patches = [ ./fedora-fixes.patch ];

  doCheck = false; # fails

  # Fix for #40213, probably permanent, because upstream doesn't seem to be
  # developed anymore. Alternatively, gcc7Stdenv could be used.
  NIX_CFLAGS_COMPILE = "-Wno-error=array-bounds";

  meta = with stdenv.lib; {
    homepage = "https://sourceforge.net/projects/omxil/";
    description = "An opensource implementation of the Khronos OpenMAX Integration Layer API to access multimedia components";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
