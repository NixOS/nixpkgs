{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libxml2, xdg-desktop-portal, gtk3, glib }:

let
  version = "0.11";
in stdenv.mkDerivation rec {
  name = "xdg-desktop-portal-gtk-${version}";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "xdg-desktop-portal-gtk";
    rev = version;
    sha256 = "03ysv29k7fp14hx0gakjigzzlniwicqd81nrhnc6w4pgin0y0zwg";
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
