{
  lib,
  stdenv,
  fetchurl,
  gtk2,
  cairo,
  glib,
  pkg-config,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goocanvas";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/goocanvas/${lib.versions.majorMinor finalAttrs.version}/goocanvas-${finalAttrs.version}.tar.bz2";
    hash = "sha256-HAcu+IVnytJB+0rd7ibpvZZ0GxUD/3NtHBUvpthlcR4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    cairo
    glib
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "goocanvas";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Canvas widget for GTK based on the the Cairo 2D library";
    homepage = "https://gitlab.gnome.org/Archive/goocanvas";
    license = licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
})
