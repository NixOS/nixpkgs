{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, itstool, libxml2, gtk3, openssl
, mysqlSupport ? false, mysql ? null
, postgresSupport ? false, postgresql ? null
}:

assert mysqlSupport -> mysql != null;
assert postgresSupport -> postgresql != null;

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  patches = [
    (fetchurl {
      name = "libgda-fix-encoding-of-copyright-headers.patch";
      url = https://bug787685.bugzilla-attachments.gnome.org/attachment.cgi?id=359901;
      sha256 = "11qj7f7zsiw8jy18vlwz2prlxpg4iq350sws3qwfwsv0lnmncmfq";
    })
  ];

  configureFlags = with stdenv.lib; [ "--enable-gi-system-install=no" ]
    ++ (optional (mysqlSupport) "--with-mysql=yes")
    ++ (optional (postgresSupport) "--with-postgres=yes");

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig intltool itstool libxml2 ];
  buildInputs = with stdenv.lib; [ gtk3 openssl ]
    ++ optional (mysqlSupport) mysql.connector-c
    ++ optional (postgresSupport) postgresql;

  meta = with stdenv.lib; {
    description = "Database access library";
    homepage = http://www.gnome-db.org/;
    license = [ licenses.lgpl2 licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
