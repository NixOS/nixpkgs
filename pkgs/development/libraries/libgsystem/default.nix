{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, gtk-doc, gobjectIntrospection
, glib, attr, systemd
}:

stdenv.mkDerivation {
  name = "libgsystem-2015.1";

  meta = with stdenv.lib; {
    description = "GIO-based library with Unix/Linux specific API";
    homepage    = "https://wiki.gnome.org/Projects/LibGSystem";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "libgsystem";
    rev = "v2015.1";
    sha256 = "0j5dqn1pnspfxifklw4wkikqlbxr4faib07550n5gi58m89gg68n";
  };

  nativeBuildInputs = [
    autoreconfHook pkgconfig gtk-doc gobjectIntrospection
  ];

  propagatedBuildInputs = [ glib attr systemd ];

  preAutoreconf = ''
    mkdir m4
  '';
}
