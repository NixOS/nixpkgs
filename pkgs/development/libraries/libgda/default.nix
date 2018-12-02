{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3, openssl, gnome3
, overrideCC, gcc6
, mysqlSupport ? false, mysql ? null
, postgresSupport ? false, postgresql ? null
}:

assert mysqlSupport -> mysql != null;
assert postgresSupport -> postgresql != null;

(if stdenv.isAarch64 then overrideCC stdenv gcc6 else stdenv).mkDerivation rec {
  name = "libgda-${version}";
  version = "5.2.5";

  src = fetchurl {
    url = "mirror://gnome/sources/libgda/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1j4hxhiwr4i8rgbn2ck93y1c2b792sfzlrq7abyjx8h8ik1f9lp3";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "libgda"; attrPath = "gnome3.libgda"; };
  };

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
