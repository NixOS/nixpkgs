{ lib, stdenv, fetchFromGitLab, pkg-config, meson, ninja, glib, gsignond, check
, json-glib, libsoup_2_4, gnutls, gtk-doc, docbook_xml_dtd_43, docbook_xml_dtd_45
, docbook_xsl, glibcLocales, gobject-introspection }:

stdenv.mkDerivation {
  pname = "gsignond-plugin-oauth";
  version = "2018-10-15";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "gsignond-plugin-oa";
    rev = "d471cebfd7c50567b1244277a9559f18f8d58691";
    sha256 = "00axl8wwp2arc6h4bpr4m3ik2hy8an0lbm48q2a9r94krmq56hnx";
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
    gnutls
    gsignond
    json-glib
    libsoup_2_4
  ];

  LC_ALL = "en_US.UTF-8";

  PKG_CONFIG_GSIGNOND_GPLUGINSDIR = "${placeholder "out"}/lib/gsignond/gplugins";

  meta = with lib; {
    description = "Plugin for the Accounts-SSO gSignOn daemon that handles the OAuth 1.0 and 2.0 authentication protocols";
    homepage = "https://gitlab.com/accounts-sso/gsignond-plugin-oa";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
