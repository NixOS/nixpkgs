{ stdenv, fetchurl, pkgconfig, libxslt, which, libX11, gnome3, gtk3, glib
, intltool, gnome-doc-utils, xkeyboard_config, isocodes, itstool, wayland
, libseccomp, bubblewrap, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gnome-desktop-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "16nbgrp0hihvrsa6kmqk0z8y7ajravyagmkmq1nnwn27psi9g8vq";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-desktop"; attrPath = "gnome3.gnome-desktop"; };
  };

  # this should probably be setuphook for glib
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig which itstool intltool libxslt gnome-doc-utils gobjectIntrospection
  ];
  buildInputs = [
    libX11 bubblewrap xkeyboard_config isocodes wayland
    gtk3 glib libseccomp
  ];

  propagatedBuildInputs = [ gnome3.gsettings-desktop-schemas ];

  patches = [
    ./bubblewrap-paths.patch
  ];

  postPatch = ''
    substituteInPlace libgnome-desktop/gnome-desktop-thumbnail-script.c --subst-var-by \
      BUBBLEWRAP_BIN "${bubblewrap}/bin/bwrap"
  '';

  meta = with stdenv.lib; {
    description = "Library with common API for various GNOME modules";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
