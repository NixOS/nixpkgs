{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, itstool, libxml2, gtk3, openssl, gnome3
, mysqlSupport ? false, mysql ? null
, postgresSupport ? false, postgresql ? null
}:

assert mysqlSupport -> mysql != null;
assert postgresSupport -> postgresql != null;

stdenv.mkDerivation rec {
  name = "libgda-${version}";
  version = "5.2.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libgda/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "2cee38dd583ccbaa5bdf6c01ca5f88cc08758b9b144938a51a478eb2684b765e";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "libgda"; attrPath = "gnome3.libgda"; };
  };

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
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
