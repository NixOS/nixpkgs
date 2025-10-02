{
  lib,
  stdenv,
  pkgsBuildBuild,
  fetchpatch,
  libtool,
  libunistring,
  buildGuile,
}:

buildGuile {
  version = "2.2.7";
  srcHash = "sha256-RLTF+74lfM3r6hhCAhLJs+kMPIalSSDYVUA5/GdpoAc=";

  depsBuildBuild = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) pkgsBuildBuild.guile_2_2;

  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  postInstall = ''
    substituteInPlace "$out/lib/pkgconfig/guile"-*.pc \
        --replace-fail "-lunistring" "-L${libunistring}/lib -lunistring" \
        --replace-fail "-lltdl" "-L${libtool.lib}/lib -lltdl" \
        --replace-fail "includedir=$out" "includedir=$dev"

    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;"
  '';

  setupHook = ./setup-hook-2.2.sh;

  meta.maintainers = with lib.maintainers; [ ludo ];
}
