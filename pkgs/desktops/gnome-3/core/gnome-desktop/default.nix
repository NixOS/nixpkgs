{ stdenv, fetchurl, substituteAll, pkgconfig, libxslt, which, libX11, gnome3, gtk3, glib
, gettext, libxml2, xkeyboard_config, isocodes, itstool, wayland, fetchpatch
, libseccomp, bubblewrap, gobject-introspection, gtk-doc, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "gnome-desktop-${version}";
  version = "3.30.2.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "07s95fpfl3kjq51yxbrx6q87w812pq6bl0xdn0zzyi6qvg33m00v";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkgconfig which itstool gettext libxslt libxml2 gobject-introspection
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
    (fetchpatch {
      name = "fix-missing-font-cache";
      url = https://gitlab.gnome.org/GNOME/gnome-desktop/commit/b87de7495160dbf48f01aa1ddb361fc2556ffd0c.patch;
      sha256 = "1aw7lw93kcflmqmbx25cwja25441i8xzvgjm1pfsxvw3vr8j6scb";
    })
  ];

  configureFlags = [
    "--enable-gtk-doc"
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
