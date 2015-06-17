{ stdenv, fetchurl, gdk_pixbuf, pkgconfig, gtk3, cyrus_sasl
, gnutls, gobjectIntrospection, vala, intltool, libgcrypt }:

stdenv.mkDerivation rec {
  versionMajor = "0.5";
  versionMinor = "4";
  moduleName   = "gtk-vnc";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "1rwwdh7lb16xdmy76ca6mpqfc3zfl3a4bkcr0qb6hs6ffrxak2j8";
  };

  buildInputs = [ pkgconfig gtk3 gdk_pixbuf gnutls cyrus_sasl
                  gobjectIntrospection vala intltool libgcrypt ];

  configureFlags = [ "--with-gtk=3.0" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/gtk-vnc;
    description = "A VNC viewer widget for GTK+";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lethalman ];
    platforms = platforms.linux;
  };
}
