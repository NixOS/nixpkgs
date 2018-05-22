{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, intltool, gnome3
, libintl }:

let
  pname = "libgnome-games-support";
  version = "1.4.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1j7lfcnc29lgn8ppn13wkn9w2y1n3lsapagwp91zh3bf0h2h4hv1";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ glib gtk3 libgee libintl ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
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
