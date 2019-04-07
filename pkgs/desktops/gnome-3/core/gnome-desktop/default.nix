{ stdenv, fetchurl, substituteAll, pkgconfig, libxslt, ninja, libX11, gnome3, gtk3, glib
, gettext, libxml2, xkeyboard_config, isocodes, meson, wayland, fetchpatch
, libseccomp, bubblewrap, gobject-introspection, gtk-doc, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "gnome-desktop-${version}";
  version = "3.32.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0m3vs3rhhykr4xnwzi18h4bb1l05l8ykpiw4mi90dz19zk2ksfd6";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig meson ninja gettext libxslt libxml2 gobject-introspection
    gtk-doc docbook_xsl
  ];
  buildInputs = [
    libX11 bubblewrap xkeyboard_config isocodes wayland
    gtk3 glib libseccomp
  ];

  propagatedBuildInputs = [ gnome3.gsettings-desktop-schemas ];

  patches = [
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Ddesktop_docs=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-desktop";
      attrPath = "gnome3.gnome-desktop";
    };
  };

  meta = with stdenv.lib; {
    description = "Library with common API for various GNOME modules";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
