{ stdenv
, lib
, fetchurl
, pkg-config
, glib
, librest
, gnome-online-accounts
, gnome
, libsoup
, json-glib
, gobject-introspection
, gtk-doc
, pkgs
, docbook-xsl-nons
}:

stdenv.mkDerivation rec {
  pname = "gfbgraph";
  version = "0.2.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "nLOBs/eLoRNt+Xrz8G47EdzCqzOawI907aD4BX1mA+M=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
  ];

  buildInputs = [
    glib
    gnome-online-accounts
  ];

  propagatedBuildInputs = [
    libsoup
    json-glib
    librest
  ];

  configureFlags = [
    "--enable-introspection"
    "--enable-gtk-doc"
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GFBGraph";
    description = "GLib/GObject wrapper for the Facebook Graph API";
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
