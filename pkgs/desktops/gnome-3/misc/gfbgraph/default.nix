{ stdenv, intltool, fetchurl, pkgconfig, glib
, gnome3, libsoup, json-glib, gobjectIntrospection }:

let
  pname = "gfbgraph";
  version = "0.2.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1dp0v8ia35fxs9yhnqpxj3ir5lh018jlbiwifjfn8ayy7h47j4fs";
  };

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
  buildInputs = [ glib gnome3.gnome-online-accounts ];
  propagatedBuildInputs = [ libsoup json-glib gnome3.rest ];

  configureFlags = [ "--enable-introspection" ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "GLib/GObject wrapper for the Facebook Graph API";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
