{ lib, stdenv, fetchurl, pkg-config, glib, dbus-glib }:

stdenv.mkDerivation rec {
  pname = "libaudclient";
  version = "3.5-rc2";

  src = fetchurl {
    url = "https://distfiles.audacious-media-player.org/${pname}-${version}.tar.bz2";
    sha256 = "0nhpgz0kg8r00z54q5i96pjk7s57krq3fvdypq496c7fmlv9kdap";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib dbus-glib ];

  meta = with lib; {
    description = "Legacy D-Bus client library for Audacious";
    homepage = "https://audacious-media-player.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
