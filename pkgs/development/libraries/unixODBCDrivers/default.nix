{fetchurl, stdenv, unixODBC, glibc, libtool, openssl, zlib, postgresql, mysql, sqlite, unixODBCDrivers}:
# each attr contains the name deriv referencing the derivation and ini which
# evaluates to a string which can be appended to the global unix odbc ini file
# to register the driver
# I haven't done any parameter tweaking.. So the defaults provided here might be bad

let

  this = unixODBCDrivers;

in
{

  # official postgres connector
  psql = stdenv.mkDerivation rec {
    name = "psqlodbc-09.03.0100";
    buildInputs = [ unixODBC libtool postgresql openssl ];
    preConfigure="
      export CPPFLAGS=-I${unixODBC}/include
      export LDFLAGS='-L${unixODBC}/lib -lltdl'
    ";
    # added -ltdl to resolve missing references `dlsym' `dlerror' `dlopen' `dlclose'
    src = fetchurl {
      url = "http://ftp.postgresql.org/pub/odbc/versions/src/${name}.tar.gz";
      sha256 = "0mh10chkmlppidnmvgbp47v5jnphsrls28zwbvyk2crcn8gdx9q1";
    };
    meta = {
        description = "unix odbc driver for postgresql";
        homepage =  http://pgfoundry.org/projects/psqlodbc/;
        license = "LGPL";
    };

    passthru.ini =
      "[PostgreSQL]\n" +
      "Description     = official PostgreSQL driver for Linux & Win32\n" +
      "Driver          = ${this.psql}/lib/psqlodbcw.so\n" +
      "Threading       = 2\n";
  };

  # mysql connector
  mysql = stdenv.mkDerivation {
    name = "mysql-connector-odbc-3.51.12";
    src = fetchurl {
      url = http://ftp.snt.utwente.nl/pub/software/mysql/Downloads/MyODBC3/mysql-connector-odbc-3.51.12.tar.gz;
      md5 = "a484f590464fb823a8f821b2f1fd7fef";
    };
    configureFlags = "--disable-gui"
       +  " --with-mysql-path=${mysql.lib} --with-unixODBC=${unixODBC}";
    buildInputs = [ libtool zlib ];
    inherit mysql unixODBC;

   meta = {
     broken = true;
   };

   passthru.ini =
     "[MYSQL]\n" +
     "Description     = MySQL driver\n" +
     "Driver          = ${this.mysql}/lib/libmyodbc3-3.51.12.so\n" +
     "CPTimeout       = \n" +
     "CPReuse         = \n" +
     "FileUsage       = 3\n ";
  };

  sqlite = let version = "0.995"; in stdenv.mkDerivation {
    name = "sqlite-connector-odbc-${version}";

    src = fetchurl {
      url = "http://www.ch-werner.de/sqliteodbc/sqliteodbc-${version}.tar.gz";
      sha256 = "1r97fw6xy5w2f8c0ii7blfqfi6salvd3k8wnxpx9wqc1gxk8jnyy";
    };

    buildInputs = [ sqlite ];

    configureFlags = "--with-sqlite3=${sqlite} --with-odbc=${unixODBC}";

    # move libraries to $out/lib where they're expected to be
    postInstall = ''
      mkdir -p "$out/lib"
      mv "$out"/*.so "$out/lib"
      mv "$out"/*.la "$out/lib"
    '';

    meta = {
      description = "ODBC driver for SQLite";
      homepage = http://www.ch-werner.de/sqliteodbc;
      license = stdenv.lib.licenses.bsd2;
      platforms = stdenv.lib.platforms.linux;
      maintainers = with stdenv.lib.maintainers; [ vlstill ];
    };

    passthru.ini =
      "[SQLite]\n" +
      "Description     = SQLite ODBC Driver\n" +
      "Driver          = ${this.sqlite}/lib/libsqlite3odbc.so\n" +
      "Setup           = ${this.sqlite}/lib/libsqlite3odbc.so\n" +
      "Threading       = 2\n";
    };

}
