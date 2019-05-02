{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3, openssl, gnome3, gobject-introspection, vala, libgee
, overrideCC, gcc6
, mysqlSupport ? false, mysql ? null
, postgresSupport ? false, postgresql ? null
}:

assert mysqlSupport -> mysql != null;
assert postgresSupport -> postgresql != null;

(if stdenv.isAarch64 then overrideCC stdenv gcc6 else stdenv).mkDerivation rec {
  pname = "libgda";
  version = "5.2.8";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0id4my5wh2m6rd7ijqp2azsjdb4l4yjrv3imq71kly00gjc6v1z2";
  };
  configureFlags = with stdenv.lib; [ "--enable-gi-system-install=no" ]
    ++ (optional (mysqlSupport) "--with-mysql=yes")
    ++ (optional (postgresSupport) "--with-postgres=yes");

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig intltool itstool libxml2 gobject-introspection vala ];
  buildInputs = with stdenv.lib; [ gtk3 openssl libgee ]
    ++ optional (mysqlSupport) mysql.connector-c
    ++ optional (postgresSupport) postgresql;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Database access library";
    homepage = https://www.gnome-db.org/;
    license = [ licenses.lgpl2 licenses.gpl2 ];
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
