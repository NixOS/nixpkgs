{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3, openssl, gnome3, gobject-introspection, vala, libgee
, overrideCC, gcc6
, mysqlSupport ? false, libmysqlclient ? null
, postgresSupport ? false, postgresql ? null
}:

assert mysqlSupport -> libmysqlclient != null;
assert postgresSupport -> postgresql != null;

(if stdenv.isAarch64 then overrideCC stdenv gcc6 else stdenv).mkDerivation rec {
  pname = "libgda";
  version = "5.2.9";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "16vxv2qvysh22s8h9h6irx96sacagxkz0i4qgi1wc6ibly6fvjjr";
  };
  configureFlags = with stdenv.lib; [
    "--enable-gi-system-install=no"
    "--with-mysql=${if mysqlSupport then "yes" else "no"}"
    "--with-postgres=${if postgresSupport then "yes" else "no"}"

    # macOS builds use the sqlite source code that comes with libgda,
    # as opposed to using the system or brewed sqlite3, which is not supported on macOS,
    # as mentioned in https://github.com/GNOME/libgda/blob/95eeca4b0470f347c645a27f714c62aa6e59f820/libgda/sqlite/README#L31,
    # which references the paper https://web.archive.org/web/20100610151539/http://lattice.umiacs.umd.edu/files/functions_tr.pdf
    # See also https://github.com/Homebrew/homebrew-core/blob/104f9ecd02854a82372b64d63d41356555378a52/Formula/libgda.rb
    "--enable-system-sqlite=${if stdenv.isDarwin then "no" else "yes"}"
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig intltool itstool libxml2 gobject-introspection vala ];
  buildInputs = with stdenv.lib; [ gtk3 openssl libgee ]
    ++ optional (mysqlSupport) libmysqlclient
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
