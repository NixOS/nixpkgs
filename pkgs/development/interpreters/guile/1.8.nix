{
  lib,
  buildGuile,
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

  enableParallelBuilding = false;

  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  postInstall = ''
    substituteInPlace "out/lib/pkgconfig/guile"-*.pc \
      --replace-fail "-lltdl" "-L${libtool.lib}/lib -lltdl"
  '';

  setupHook = ./setup-hook-1.8.sh;

  maintainers = with lib.maintainers; [ ludo ];
}
