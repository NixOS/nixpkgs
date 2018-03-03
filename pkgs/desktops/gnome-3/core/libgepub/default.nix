{ stdenv, fetchurl, meson, ninja, pkgconfig, glib, gobjectIntrospection, gnome3
, webkitgtk, libsoup, libxml2, libarchive }:

let
  pname = "libgepub";
  version = "0.5.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0f1bczy3b00kj7mhm80xgpcgibh8h0pgcr46l4wifi45jacji0w4";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection ];
  buildInputs = [ glib webkitgtk libsoup libxml2 libarchive ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "GObject based library for handling and rendering epub documents";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
