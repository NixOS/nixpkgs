{ stdenv, fetchurl, meson, ninja, pkgconfig, exiv2, glib, gnome3, gobject-introspection, vala }:

let
  pname = "gexiv2";
  version = "0.10.9";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1vf0zv92p9hybdhn7zx53h3ia53ph97a21xz8rfk877xlr5261l8";
  };

  preConfigure = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection vala ];
  buildInputs = [ glib ];
  propagatedBuildInputs = [ exiv2 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/gexiv2;
    description = "GObject wrapper around the Exiv2 photo metadata library";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
