{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook
, mono, gtk-sharp-3_0, dbus-sharp-1_0, dbus-sharp-glib-1_0 }:

stdenv.mkDerivation rec {
  name = "notify-sharp-${version}";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "notify-sharp";

    rev = "${version}";
    sha256 = "1vm7mnmxdwrgy4mr07lfva8sa6a32f2ah5x7w8yzcmahaks3sj5m";
  };

  nativeBuildInputs = [
    pkgconfig autoreconfHook
  ];

  buildInputs = [
    mono gtk-sharp-3_0
    dbus-sharp-1_0 dbus-sharp-glib-1_0
  ];

  dontStrip = true;

  postPatch = ''
    sed -i 's#^[ \t]*DOCDIR=.*$#DOCDIR=$out/lib/monodoc#' ./configure.ac
  '';

  meta = with stdenv.lib; {
    description = "D-Bus for .NET";
    platforms = platforms.linux;
  };
}
