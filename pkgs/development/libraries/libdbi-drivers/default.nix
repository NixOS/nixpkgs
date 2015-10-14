{ stdenv, fetchurl, libdbi
, libmysql ? null, sqlite ? null, postgresql ? null
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libdbi-drivers-0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/libdbi-drivers/${name}.tar.gz";
    sha256 = "0m680h8cc4428xin4p733azysamzgzcmv4psjvraykrsaz6ymlj3";
  };

  buildInputs = [ libdbi libmysql sqlite postgresql ];

  postPatch = ''
    sed -i '/SQLITE3_LIBS/ s/-lsqlite/-lsqlite3/' configure;
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-docs"
    "--enable-libdbi"
    "--with-dbi-incdir=${libdbi}/include"
    "--with-dbi-libdir=${libdbi}/lib"
  ] ++ optionals (libmysql != null) [
    "--with-mysql"
    "--with-mysql-incdir=${libmysql}/include/mysql"
    "--with-mysql-libdir=${libmysql}/lib/mysql"
  ] ++ optionals (postgresql != null) [
    "--with-pgsql"
    "--with-pgsql_incdir=${postgresql}/include"
    "--with-pgsql_libdir=${postgresql.lib}/lib"
  ] ++ optionals (sqlite != null) [
    "--with-sqlite3"
    "--with-sqlite3-incdir=${sqlite.dev}/include/sqlite"
    "--with-sqlite3-libdir=${sqlite.out}/lib/sqlite"
  ];

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall = ''
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done

    # Remove the unneeded var/lib directories
    rm -rf $out/var
  '';
    
  meta = {
    homepage = http://libdbi-drivers.sourceforge.net/;
    description = "Database drivers for libdbi";
    platforms = platforms.all;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ wkennington ];
  };
}
