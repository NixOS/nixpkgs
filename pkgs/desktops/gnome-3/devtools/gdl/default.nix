{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, gnome3, intltool }:

stdenv.mkDerivation rec {
  name = "gdl-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdl/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1dipnzqpxl0yfwzl2lqdf6vb3174gb9f1d5jndkq8505q7n9ik2j";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gdl"; attrPath = "gnome3.gdl"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxml2 gtk3 intltool ];

  meta = with stdenv.lib; {
    description = "Gnome docking library";
    homepage = https://developer.gnome.org/gdl/;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
