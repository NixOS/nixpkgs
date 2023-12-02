{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, glib
, libxml2
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gupnp-av";
  version = "0.14.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "t5zgzEsMZtnFS8Ihg6EOVwmgAR0q8nICWUjvyrM6Pk8=";
  };

  patches = [
    # Fix build with libxml 2.12
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gupnp-av/-/commit/1e10a41fcef6ae0d3e89958db89bc22398f3b4f1.patch";
      hash = "sha256-APeHsLFwSCVuSGc7IXdKaPURU5k5J2nB2jVOABEdRcA=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    libxml2
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=deprecated-declarations"
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "http://gupnp.org/";
    description = "A collection of helpers for building AV (audio/video) applications using GUPnP";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
