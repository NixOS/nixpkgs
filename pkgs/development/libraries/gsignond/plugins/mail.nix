{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  gsignond,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "gsignond-plugin-mail";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "gsignond-plugin-mail";
    rev = version;
    sha256 = "0x8jcl0ra9kacm80f1im5wpxp9r9wxayjwnk6dkv7fhjbl2p4nh0";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    gsignond
  ];

  PKG_CONFIG_GSIGNOND_GPLUGINSDIR = "${placeholder "out"}/lib/gsignond/gplugins";

  meta = with lib; {
    description = "Plugin for the Accounts-SSO gSignOn daemon that handles E-Mail credentials";
    homepage = "https://gitlab.com/accounts-sso/gsignond-plugin-mail";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
