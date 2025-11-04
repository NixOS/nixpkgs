{
  lib,
  stdenv,
  pkgsBuildBuild,
  buildGuile,
  libtool,
}:

buildGuile {
  version = "1.8.8";
  srcHash = "sha256-w0cf7S5y5bBK0TO7qvFjaeg2AoNnm88ZgAvBs4ECQFA=";

  patches = [
    # Fix doc snarfing with GCC 4.5.
    ./cpp-4.5.patch
    # Self explanatory
    ./CVE-2016-8605.patch
  ];

  postPatch = ''
    sed -e '/lt_dlinit/a  lt_dladdsearchdir("'$out/lib'");' -i libguile/dynl.c
  '';

  depsBuildBuild = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) pkgsBuildBuild.guile_1_8;

  enableParallelBuilding = false;

  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  postInstall = ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|-lltdl|-L${libtool.lib}/lib -lltdl|g"
  '';

  meta.maintainers = with lib.maintainers; [ RossSmyth ];
}
