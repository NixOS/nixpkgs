{ fetchurl, stdenv, unixODBC, cmake, postgresql, mysql55, mariadb, sqlite, zlib, libxml2 }:

# I haven't done any parameter tweaking.. So the defaults provided here might be bad

{
  psql = stdenv.mkDerivation rec {
    name = "psqlodbc-${version}";
    version = "10.01.0000";

    src = fetchurl {
      url = "http://ftp.postgresql.org/pub/odbc/versions/src/${name}.tar.gz";
      sha256 = "1cyams7157f3gry86x64xrplqi2vyqrq3rqka59gv4lb4rpl7jl7";
    };

    buildInputs = [ unixODBC postgresql ];

    passthru = {
      fancyName = "PostgreSQL";
      driver = "lib/psqlodbcw.so";
    };

    meta = with stdenv.lib; {
      description = "Official PostgreSQL ODBC Driver";
      homepage =  https://odbc.postgresql.org/;
      license = licenses.lgpl2;
      platforms = platforms.linux;
    };
  };

  mariadb = stdenv.mkDerivation rec {
    name = "mariadb-connector-odbc-${version}";
    version = "2.0.10";

    src = fetchurl {
      url = "https://downloads.mariadb.org/interstitial/connector-odbc-${version}/src/${name}-ga-src.tar.gz";
      sha256 = "0b6ximy0dg0xhqbrm1l7pn8hjapgpmddi67kh54h6i9cq9hqfdvz";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ unixODBC mariadb.connector-c ];

    cmakeFlags = [
      "-DMARIADB_INCLUDE_DIR=${mariadb.connector-c}/include/mariadb"
    ];

    passthru = {
      fancyName = "MariaDB";
      driver = "lib/libmyodbc3-3.51.12.so";
    };

    meta = with stdenv.lib; {
      description = "MariaDB ODBC database driver";
      homepage =  https://downloads.mariadb.org/connector-odbc/;
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };

  mysql = stdenv.mkDerivation rec {
    name = "mysql-connector-odbc-${version}";
    majorVersion = "5.3";
    version = "${majorVersion}.6";

    src = fetchurl {
      url = "https://dev.mysql.com/get/Downloads/Connector-ODBC/${majorVersion}/${name}-src.tar.gz";
      sha256 = "1smi4z49i4zm7cmykjkwlxxzqvn7myngsw5bc35z6gqxmi8c55xr";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ unixODBC mysql55 ];

    cmakeFlags = [ "-DWITH_UNIXODBC=1" ];

    passthru = {
      fancyName = "MySQL";
      driver = "lib/libmyodbc3-3.51.12.so";
    };

    meta = with stdenv.lib; {
      description = "MariaDB ODBC database driver";
      homepage = https://dev.mysql.com/downloads/connector/odbc/;
      license = licenses.gpl2;
      platforms = platforms.linux;
      broken = true;
    };
  };

  sqlite = stdenv.mkDerivation rec {
    name = "sqlite-connector-odbc-${version}";
    version = "0.9993";
 
    src = fetchurl {
      url = "http://www.ch-werner.de/sqliteodbc/sqliteodbc-${version}.tar.gz";
      sha256 = "0dgsj28sc7f7aprmdd0n5a1rmcx6pv7170c8dfjl0x1qsjxim6hs";
    };
 
    buildInputs = [ unixODBC sqlite zlib libxml2 ];
 
    configureFlags = [ "--with-odbc=${unixODBC}" ];
 
    installTargets = [ "install-3" ];

    # move libraries to $out/lib where they're expected to be
    postInstall = ''
      mkdir -p "$out/lib"
      mv "$out"/*.* "$out/lib"
    '';
 
    passthru = {
      fancyName = "SQLite";
      driver = "lib/libsqlite3odbc.so";
    };

    meta = with stdenv.lib; {
      description = "ODBC driver for SQLite";
      homepage = http://www.ch-werner.de/sqliteodbc;
      license = licenses.bsd2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ vlstill ];
    };
  };
}
