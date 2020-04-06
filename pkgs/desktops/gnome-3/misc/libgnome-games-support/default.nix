{ stdenv, fetchurl, pkgconfig, glib, gtk3, libgee, gettext, vala, gnome3
, libintl, meson, ninja }:

let
  pname = "libgnome-games-support";
  version = "1.6.0.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0xifkj5dg4n3cy0hi76zy1ixyssxxpgy4yi4li7iq39cqbnkc9d8";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext vala ];
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
