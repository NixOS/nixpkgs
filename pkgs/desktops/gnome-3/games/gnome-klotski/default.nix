{ stdenv, fetchurl, pkgconfig, vala, gnome3, gtk3, wrapGAppsHook, appstream-glib, desktop-file-utils
, glib, librsvg, libxml2, intltool, itstool, libgee, libgnome-games-support }:

let
  pname = "gnome-klotski";
  version = "3.31.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1kh6sbcczc60bxxnd10g4vz8cz0gcziq04pqcxsi816fy1jiixq4";
  };

  nativeBuildInputs = [ pkgconfig vala wrapGAppsHook intltool itstool libxml2 appstream-glib desktop-file-utils ];
  buildInputs = [ glib gtk3 librsvg libgee libgnome-games-support gnome3.defaultIconTheme ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "${pname}";
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Klotski;
    description = "Slide blocks to solve the puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
