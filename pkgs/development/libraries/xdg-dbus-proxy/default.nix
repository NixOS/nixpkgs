{ stdenv, fetchurl, pkgconfig, libxslt, docbook_xsl, docbook_xml_dtd_43, dbus, glib }:

stdenv.mkDerivation rec {
  pname = "xdg-dbus-proxy";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/flatpak/xdg-dbus-proxy/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "1w8yg5j51zsr9d97d4jjp9dvd7iq893p2xk54i6lf3lx01ribdqh";
  };

  nativeBuildInputs = [ pkgconfig libxslt docbook_xsl docbook_xml_dtd_43 ];
  buildInputs = [ glib ];
  checkInputs = [ dbus ];

  configureFlags = [
    "--enable-man"
  ];

  # dbus[2345]: Failed to start message bus: Failed to open "/etc/dbus-1/session.conf": No such file or directory
  doCheck = false;

  meta = with stdenv.lib; {
    description = "DBus proxy for Flatpak and others";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
