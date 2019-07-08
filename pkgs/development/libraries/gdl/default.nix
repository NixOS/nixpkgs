{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, gnome3, intltool }:

stdenv.mkDerivation rec {
  pname = "gdl";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdl/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1dipnzqpxl0yfwzl2lqdf6vb3174gb9f1d5jndkq8505q7n9ik2j";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ libxml2 gtk3 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gdl";
    };
  };

  meta = with stdenv.lib; {
    description = "Gnome docking library";
    homepage = https://developer.gnome.org/gdl/;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
