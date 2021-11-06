{ fetchurl, stdenv, unixODBC, cmake, postgresql, mariadb, sqlite, zlib, libxml2, dpkg, lib, openssl, libkrb5, libuuid, patchelf, libiconv, fetchFromGitHub }:

# I haven't done any parameter tweaking.. So the defaults provided here might be bad

{
  psql = stdenv.mkDerivation rec {
    pname = "psqlodbc";
    version = "10.01.0000";

    src = fetchurl {
      url = "mirror://postgresql/odbc/versions/src/${pname}-${version}.tar.gz";
      sha256 = "1cyams7157f3gry86x64xrplqi2vyqrq3rqka59gv4lb4rpl7jl7";
    };

    buildInputs = [ unixODBC postgresql ];

    passthru = {
      fancyName = "PostgreSQL";
      driver = "lib/psqlodbcw.so";
    };

    meta = with lib; {
      description = "Official PostgreSQL ODBC Driver";
      homepage =  "https://odbc.postgresql.org/";
      license = licenses.lgpl2;
      platforms = platforms.linux;
    };
  };

  mariadb = stdenv.mkDerivation rec {
    pname = "mariadb-connector-odbc";
    version = "3.1.4";

    src = fetchFromGitHub {
      owner = "MariaDB";
      repo = "mariadb-connector-odbc";
      rev = version;
      sha256 = "1kbz5mng9vx89cw2sx7gsvhbv4h86zwp31fr0hxqing3cwxhkfgw";
      # this driver only seems to build correctly when built against the mariadb-connect-c subrepo
      # (see https://github.com/NixOS/nixpkgs/issues/73258)
      fetchSubmodules = true;
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ unixODBC openssl libiconv ];

    preConfigure = ''
      # we don't want to build a .pkg
      sed -i 's/ADD_SUBDIRECTORY(osxinstall)//g' CMakeLists.txt
    '';

    cmakeFlags = [
      "-DWITH_OPENSSL=ON"
      # on darwin this defaults to ON but we want to build against unixODBC
      "-DWITH_IODBC=OFF"
    ];

    passthru = {
      fancyName = "MariaDB";
      driver = "lib/libmaodbc${stdenv.hostPlatform.extensions.sharedLibrary}";
    };

    meta = with lib; {
      description = "MariaDB ODBC database driver";
      homepage =  "https://downloads.mariadb.org/connector-odbc/";
      license = licenses.gpl2;
      platforms = platforms.linux ++ platforms.darwin;
    };
  };

  mysql = stdenv.mkDerivation rec {
    pname = "mysql-connector-odbc";
    majorVersion = "5.3";
    version = "${majorVersion}.6";

    src = fetchurl {
      url = "https://dev.mysql.com/get/Downloads/Connector-ODBC/${majorVersion}/${pname}-${version}-src.tar.gz";
      sha256 = "1smi4z49i4zm7cmykjkwlxxzqvn7myngsw5bc35z6gqxmi8c55xr";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [ unixODBC mariadb ];

    cmakeFlags = [ "-DWITH_UNIXODBC=1" ];

    passthru = {
      fancyName = "MySQL";
      driver = "lib/libmyodbc3-3.51.12.so";
    };

    meta = with lib; {
      description = "MariaDB ODBC database driver";
      homepage = "https://dev.mysql.com/downloads/connector/odbc/";
      license = licenses.gpl2;
      platforms = platforms.linux;
      broken = true;
    };
  };

  sqlite = stdenv.mkDerivation rec {
    pname = "sqlite-connector-odbc";
    version = "0.9993";

    src = fetchurl {
      url = "http://www.ch-werner.de/sqliteodbc/sqliteodbc-${version}.tar.gz";
      sha256 = "0dgsj28sc7f7aprmdd0n5a1rmcx6pv7170c8dfjl0x1qsjxim6hs";
    };

    buildInputs = [ unixODBC sqlite zlib libxml2 ];

    configureFlags = [ "--with-odbc=${unixODBC}" "--with-sqlite3=${sqlite.dev}" ];

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

    meta = with lib; {
      description = "ODBC driver for SQLite";
      homepage = "http://www.ch-werner.de/sqliteodbc";
      license = licenses.bsd2;
      platforms = platforms.linux;
      maintainers = with maintainers; [ vlstill ];
    };
  };

  msodbcsql17 = stdenv.mkDerivation rec {
    pname = "msodbcsql17";
    version = "${versionMajor}.${versionMinor}.${versionAdditional}-1";

    versionMajor = "17";
    versionMinor = "7";
    versionAdditional = "1.1";

    src = fetchurl {
      url = "https://packages.microsoft.com/debian/10/prod/pool/main/m/msodbcsql17/msodbcsql${versionMajor}_${version}_amd64.deb";
      sha256 = "0vwirnp56jibm3qf0kmi4jnz1w7xfhnsfr8imr0c9hg6av4sk3a6";
    };

    nativeBuildInputs = [ dpkg patchelf ];

    unpackPhase = "dpkg -x $src ./";
    buildPhase = "";

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/lib
      cp -r opt/microsoft/msodbcsql${versionMajor}/lib64 opt/microsoft/msodbcsql${versionMajor}/share $out/
    '';

    postFixup = ''
      patchelf --set-rpath ${lib.makeLibraryPath [ unixODBC openssl.out libkrb5 libuuid stdenv.cc.cc ]} \
        $out/lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}
    '';

    passthru = {
      fancyName = "ODBC Driver 17 for SQL Server";
      driver = "lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}";
    };

    meta = with lib; {
      description = "ODBC Driver 17 for SQL Server";
      homepage = "https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = with maintainers; [ spencerjanssen ];
    };
  };
}
