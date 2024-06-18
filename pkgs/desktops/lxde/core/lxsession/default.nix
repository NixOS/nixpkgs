{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, docbook_xml_dtd_412
, docbook_xsl
, intltool
, libxml2
, libxslt
, pkg-config
, wrapGAppsHook3
, gtk2-x11
, libX11
, polkit
, vala
}:

stdenv.mkDerivation rec {
  pname = "lxsession";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "lxsession";
    rev = version;
    sha256 = "17sqsx57ymrimm5jfmcyrp7b0nzi41bcvpxsqckmwbhl19g6c17d";
  };

  patches = [ ./xmlcatalog_patch.patch ];

  nativeBuildInputs = [
    autoconf
    automake
    docbook_xml_dtd_412
    docbook_xsl
    intltool
    libxml2
    libxslt
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk2-x11
    libX11
    polkit
    vala
  ];

  configureFlags = [
    "--enable-man"
    "--disable-buildin-clipboard"
    "--disable-buildin-polkit"
    "--with-xml-catalog=${docbook_xml_dtd_412}/xml/dtd/docbook/catalog.xml"
  ];

  preConfigure = "./autogen.sh";

  meta = with lib; {
    homepage = "https://wiki.lxde.org/en/LXSession";
    description = "Classic LXDE session manager";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.shamilton ];
    platforms = platforms.linux;
  };
}
