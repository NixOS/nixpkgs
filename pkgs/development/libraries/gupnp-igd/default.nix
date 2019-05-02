{ stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, pkgconfig
, gettext
, gobject-introspection
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_412
, glib
, gupnp
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gupnp-igd";
  version = "0.2.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "081v1vhkbz3wayv49xfiskvrmvnpx93k25am2wnarg5cifiiljlb";
  };

  patches = [
    # Add gupnp-1.2 compatibility
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gupnp-igd/commit/63531558a16ac2334a59f627b2fca5576dcfbb2e.patch;
      sha256 = "0s8lkyy9fnnnnkkqwbk6gxb7795bb1kl1swk5ldjnlrzhfcy1ab2";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    autoreconfHook
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
  ];

  propagatedBuildInputs = [
    glib
    gupnp
  ];

  configureFlags = [
    "--enable-gtk-doc"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Library to handle UPnP IGD port mapping";
    homepage = http://www.gupnp.org/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
