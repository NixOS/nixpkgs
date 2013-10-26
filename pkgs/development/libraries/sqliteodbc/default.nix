{ stdenv, fetchurl, sqlite, unixODBC }:

let version = "0.995";
in
stdenv.mkDerivation ({
  name = "sqliteodbc-${version}";

  src = fetchurl {
    url = "http://www.ch-werner.de/sqliteodbc/sqliteodbc-${version}.tar.gz";
    sha256 = "1r97fw6xy5w2f8c0ii7blfqfi6salvd3k8wnxpx9wqc1gxk8jnyy";
  };

  buildInputs = [ sqlite unixODBC ];

  configureFlags = "--with-sqlite3=${sqlite} --with-odbc=${unixODBC}";

  # sqliteodbc does not create lib directory in make and install libraries
  # directly to prefix if it is missing
  preInstall = ''
      mkdir -p $out/lib
  '';

  meta = {
    homepage = http://www.ch-werner.de/sqliteodbc/;
    description = "ODBC driver for SQLite";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
  };
})
