{ stdenv, fetchurl, pkgconfig, glib, dbus-glib }:

stdenv.mkDerivation rec {
  name = "libaudclient-3.5-rc2";
  version = "3.5-rc2";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/${name}.tar.bz2";
    sha256 = "0nhpgz0kg8r00z54q5i96pjk7s57krq3fvdypq496c7fmlv9kdap";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib dbus-glib ];

  meta = with stdenv.lib; {
    description = "Legacy D-Bus client library for Audacious";
    homepage = http://audacious-media-player.org/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
