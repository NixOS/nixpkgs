{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libomxil-bellagio";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/omxil/omxil/Bellagio%20${version}/${pname}-${version}.tar.gz";
    sha256 = "0k6p6h4npn8p1qlgq6z3jbfld6n1bqswzvxzndki937gr0lhfg2r";
  };

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  patches = [
    ./fedora-fixes.patch
    ./fno-common.patch
    # Fix stack overread: https://sourceforge.net/p/omxil/patches/8/
    (fetchurl {
      name = "no-overread.patch";
      url = "https://sourceforge.net/p/omxil/patches/8/attachment/0001-src-base-omx_base_component.c-fix-stack-overread.patch";
      hash = "sha256-ElpiDxU0Ii4Ou8ebVx4Ne9UnB6mesC8cRj77N7LdovA=";
    })
  ];

  # Disable parallel build as it fails as:
  #    ld: cannot find -lomxil-bellagio
  enableParallelBuilding = false;

  doCheck = false; # fails

  env.NIX_CFLAGS_COMPILE =
    # stringop-truncation: see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1028978
    if stdenv.cc.isGNU then
      "-Wno-error=array-bounds -Wno-error=stringop-overflow=8 -Wno-error=stringop-truncation"
    else
      let
        isLLVM17 = stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17";
      in
      "-Wno-error=absolute-value -Wno-error=enum-conversion -Wno-error=logical-not-parentheses -Wno-error=non-literal-null-conversion${lib.optionalString (isLLVM17) " -Wno-error=unused-but-set-variable"}";

  meta = with lib; {
    homepage = "https://omxil.sourceforge.net/";
    description = "An opensource implementation of the Khronos OpenMAX Integration Layer API to access multimedia components";
    mainProgram = "omxregister-bellagio";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
