{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, gettext, gnome3
, libintl }:

let
  pname = "libgnome-games-support";
  version = "1.4.4";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1zkbmnrn161p74qg6jhsn9f66yjjzxfm13pl1klv9av8k1bax9pq";
  };

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ libintl ];
  propagatedBuildInputs = [
    # Required by libgnome-games-support-1.pc
    glib gtk3 libgee
  ];

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
