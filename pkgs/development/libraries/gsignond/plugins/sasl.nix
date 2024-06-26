{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  glib,
  gsignond,
  gsasl,
  check,
  gtk-doc,
  docbook_xml_dtd_43,
  docbook_xml_dtd_45,
  docbook_xsl,
  glibcLocales,
  gobject-introspection,
}:

stdenv.mkDerivation {
  pname = "gsignond-plugin-sasl";
  version = "2018-10-15";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "gsignond-plugin-sasl";
    rev = "b304c70b7dad9368b23b1205122d10de684c896a";
    sha256 = "0knzw7c2fm2kzs1gxbrm4kk67522w9cpwqj7xvn86473068k90va";
  };

  nativeBuildInputs = [
    check
    docbook_xml_dtd_43
    docbook_xml_dtd_45
    docbook_xsl
    glibcLocales
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
    gsasl
    gsignond
  ];

  LC_ALL = "en_US.UTF-8";

  PKG_CONFIG_GSIGNOND_GPLUGINSDIR = "${placeholder "out"}/lib/gsignond/gplugins";

  meta = with lib; {
    description = "Plugin for the Accounts-SSO gSignOn daemon that handles the SASL authentication protocol";
    homepage = "https://gitlab.com/accounts-sso/gsignond-plugin-sasl";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
