{ stdenv, fetchurl, pkgconfig, glib, intltool, json-glib, rest, libsoup, gtk, gnome-online-accounts, gnome3 }:
let
  pname = "libzapojit";
  version = "0.0.3";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0zn3s7ryjc3k1abj4k55dr2na844l451nrg9s6cvnnhh569zj99x";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ glib json-glib rest libsoup gtk gnome-online-accounts ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "GObject wrapper for the SkyDrive and Hotmail REST APIs";
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
