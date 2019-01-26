{ stdenv, fetchurl, meson, ninja, glib, pkgconfig, gnome3, appstream-glib, gettext }:

let
  pname = "nautilus-sendto";
  version = "3.8.6";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";


  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/3.8/${name}.tar.xz";
    sha256 = "164d7c6e8bae29c4579bcc67a7bf50d783662b1545b62f3008e7ea3c0410e04d";
  };

  nativeBuildInputs = [ meson ninja pkgconfig appstream-glib gettext ];
  buildInputs = [ glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Integrates Evolution and Pidgin into the Nautilus file manager";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
