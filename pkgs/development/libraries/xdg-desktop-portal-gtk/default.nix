{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libxml2, xdg-desktop-portal, gtk3, glib }:

let
  version = "1.0.2";
in stdenv.mkDerivation rec {
  name = "xdg-desktop-portal-gtk-${version}";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal-gtk";
    rev = version;
    sha256 = "06dzh3vzq5nw3r89kb1qi3r2z8wjh9zmzc0hfnva4vnx7mwgm7ax";
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
