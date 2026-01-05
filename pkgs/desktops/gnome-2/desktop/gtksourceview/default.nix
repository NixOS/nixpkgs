{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  autoreconfHook,
  gtk-doc,
  pkg-config,
  atk,
  cairo,
  glib,
  gnome-common,
  gtk2,
  pango,
  libxml2Python,
  perl,
  intltool,
  gettext,
  gtk-mac-integration-gtk2,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtksourceview";
  version = "2.10.5";

  src =
    let
      inherit (finalAttrs) pname version;
    in
    fetchurl {
      url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
      sha256 = "c585773743b1df8a04b1be7f7d90eecdf22681490d6810be54c81a7ae152191e";
    };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (fetchpatch {
      name = "change-igemacintegration-to-gtkosxapplication.patch";
      url = "https://gitlab.gnome.org/GNOME/gtksourceview/commit/e88357c5f210a8796104505c090fb6a04c213902.patch";
      sha256 = "0h5q79q9dqbg46zcyay71xn1pm4aji925gjd5j93v4wqn41wj5m7";
    })
    (fetchpatch {
      name = "update-to-gtk-mac-integration-2.0-api.patch";
      url = "https://gitlab.gnome.org/GNOME/gtksourceview/commit/ab46e552e1d0dae73f72adac8d578e40bdadaf95.patch";
      sha256 = "0qzrbv4hpa0v8qbmpi2vp575n13lkrvp3cgllwrd2pslw1v9q3aj";
    })
  ];

  # Fix build with gcc 14
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  nativeBuildInputs = [
    pkg-config
    intltool
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    autoreconfHook
    gtk-doc
  ];

  buildInputs = [
    atk
    cairo
    glib
    gtk2
    pango
    libxml2Python
    perl
    gettext
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    gnome-common
    gtk-mac-integration-gtk2
  ];

  doCheck = false; # requires X11 daemon

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    pkgConfigModules = [ "gtksourceview-2.0" ];
  };
})
