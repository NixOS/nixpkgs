{ stdenv, fetchFromGitHub, autoreconfHook, which, pkgconfig, mono, gtk-sharp, gio-sharp }:

stdenv.mkDerivation rec {
  name = "gtk-sharp-beans-${version}";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "gtk-sharp-beans";

    rev = "${version}";
    sha256 = "04sylwdllb6gazzs2m4jjfn14mil9l3cny2q0xf0zkhczzih6ah1";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook which ];
  buildInputs = [ mono gtk-sharp gio-sharp ];

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "gtk-sharp-beans binds some API from Gtk+ that isn't in Gtk# 2.12.x";
    platforms = platforms.linux;
  };
}
