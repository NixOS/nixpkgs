{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, intltool, gnome3 }:

let
  pname = "libgnome-games-support";
  version = "1.2.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1vwad7kqy7yd6wqyr71nq0blh7m53r3lz6ya16dmh942kd0w48v1";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ glib gtk3 libgee ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.libgames-support";
    };
  };

  meta = with stdenv.lib; {
    description = "Small library intended for internal use by GNOME Games, but it may be used by others";
    homepage = https://wiki.gnome.org/Apps/Games;
    license = licenses.lgpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
