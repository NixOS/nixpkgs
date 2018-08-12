{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libxml2, xdg-desktop-portal, gtk3, glib }:

let
  version = "0.99";
in stdenv.mkDerivation rec {
  name = "xdg-desktop-portal-gtk-${version}";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal-gtk";
    rev = version;
    sha256 = "0jnmrl55gpvz06hy0832kcby4y84f0a1hiali6qy1lcmyqhm3v59";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig libxml2 xdg-desktop-portal ];
  buildInputs = [ glib gtk3 ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
