{ stdenv, fetchFromGitLab, pkgconfig, meson, ninja, vala, glib, gsignond, json-glib, libsoup, gobject-introspection }:

stdenv.mkDerivation rec {
  name = "gsignond-plugin-lastfm-${version}";
  version = "2018-05-07";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "gsignond-plugin-lastfm";
    rev = "0a7a5f8511282e45cfe35987b81f27f158f0648c";
    sha256 = "0ay6ir9zg9l0264x5xwd7c6j8qmwlhrifkkkjd1yrjh9sqxyfj7f";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    glib
    gsignond
    json-glib
    libsoup
  ];

  PKG_CONFIG_GSIGNOND_GPLUGINSDIR = "${placeholder "out"}/lib/gsignond/gplugins";

  meta = with stdenv.lib; {
    description = "Plugin for the Accounts-SSO gSignOn daemon that handles Last.FM credentials";
    homepage = https://gitlab.com/accounts-sso/gsignond-plugin-lastfm;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
