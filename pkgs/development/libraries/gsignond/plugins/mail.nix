{ stdenv, fetchFromGitLab, pkgconfig, meson, ninja, vala, glib, gsignond, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gsignond-plugin-mail-${version}";
  version = "2018-10-04";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "gsignond-plugin-mail";
    rev = "fbc6f34b246fec4ad2b37c696f8de7fdb9bde346";
    sha256 = "1wvwz7qiwvj8iixprip3qd8lplzfnwcjfrbg2vd8xfsvid2zbviw";
  };

  nativeBuildInputs = [
    gobjectIntrospection
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    glib
    gsignond
  ];

  PKG_CONFIG_GSIGNOND_GPLUGINSDIR = "${placeholder "out"}/lib/gsignond/gplugins";

  meta = with stdenv.lib; {
    description = "Plugin for the Accounts-SSO gSignOn daemon that handles the E-Mail credentials.";
    homepage = https://gitlab.com/accounts-sso/gsignond-plugin-mail;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
