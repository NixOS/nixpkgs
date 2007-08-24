{stdenv, fetchurl, mysql, libtool, zlib, unixODBC}:

stdenv.mkDerivation {
  name = "mysql-connector-odbc-3.51.12";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.snt.utwente.nl/pub/software/mysql/Downloads/MyODBC3/mysql-connector-odbc-3.51.12.tar.gz;
    md5 = "a484f590464fb823a8f821b2f1fd7fef";
  };
  configureFlags = "--disable-gui";
  buildInputs = [libtool zlib];
  inherit mysql unixODBC;
}
