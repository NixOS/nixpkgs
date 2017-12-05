{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3, openssl }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  patches = [
    (fetchurl {
      name = "libgda-fix-encoding-of-copyright-headers.patch";
      url = https://bug787685.bugzilla-attachments.gnome.org/attachment.cgi?id=359901;
      sha256 = "11qj7f7zsiw8jy18vlwz2prlxpg4iq350sws3qwfwsv0lnmncmfq";
    })
  ];

  configureFlags = [
    "--enable-gi-system-install=no"
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool itstool libxml2 gtk3 openssl ];

  meta = with stdenv.lib; {
    description = "Database access library";
    homepage = http://www.gnome-db.org/;
    license = [ licenses.lgpl2 licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
