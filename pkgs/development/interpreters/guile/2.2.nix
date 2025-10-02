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
  srcHash = "sha256-zfd26l8pQwsSWCCWMFVb7qbSvlSB+dpNZJhrB3/zdQQ=";

  patches = lib.optional stdenv.hostPlatform.isDarwin (fetchpatch {
    url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
    hash = "sha256-BwgdtWvRgJEAnzqK2fCQgRHU0va50VR6SQfJpGzjm4s=";
  });

  depsBuildBuild = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) pkgsBuildBuild.guile_2_2;

  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  postInstall = ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;
            s|-lltdl|-L${libtool.lib}/lib -lltdl|g ;
            s|includedir=$out|includedir=$dev|g
            "
  '';

  setupHook = ./setup-hook-2.2.sh;

  meta.maintainers = with lib.maintainers; [ ludo ];
}
