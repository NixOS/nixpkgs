{ fetchFromGitHub, glib, gobject-introspection, meson, ninja, pkgconfig, stdenv, wrapGAppsHook, libxml2, cmake, gtk3, libnotify, cinnamon-desktop, xapps, libexif, exempi, intltool }:

stdenv.mkDerivation rec {
  pname = "nemo";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0sskq0rssxvna937md446x1489hkhxys1zq03hvl8asjqa259w2q";
  };

  patches = [ ./0001-patch-datadir.patch ./0002-patch-remove-update-mime-db-script.patch ];

  NIX_CFLAGS_COMPILE = [ "-I${glib.dev}/include/gio-unix-2.0" ];

  buildInputs = [ glib pkgconfig gtk3 libnotify cinnamon-desktop libxml2 xapps libexif exempi ];
  nativeBuildInputs = [ meson gobject-introspection ninja wrapGAppsHook cmake intltool ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/nemo";
    description = "File browser for Cinnamon";

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
