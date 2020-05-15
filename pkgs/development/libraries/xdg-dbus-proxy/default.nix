{ stdenv
, fetchurl
, pkgconfig
, libxslt
, docbook_xsl
, docbook_xml_dtd_43
, dbus
, glib
}:

stdenv.mkDerivation rec {
  pname = "xdg-dbus-proxy";
  version = "0.1.2";

  src = fetchurl {
    url = "https://github.com/flatpak/xdg-dbus-proxy/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "03sj1h0c2l08xa8phw013fnxr4fgav7l2mkjhzf9xk3dykwxcj8p";
  };

  nativeBuildInputs = [
    pkgconfig
    libxslt
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
  ];

  checkInputs = [
    dbus
  ];

  configureFlags = [
    "--enable-man"
  ];

  # dbus[2345]: Failed to start message bus: Failed to open "/etc/dbus-1/session.conf": No such file or directory
  doCheck = false;

  meta = with stdenv.lib; {
    description = "DBus proxy for Flatpak and others";
    homepage = "https://github.com/flatpak/xdg-dbus-proxy";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
