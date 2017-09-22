{ stdenv, fetchurl, autoreconfHook, pkgconfig
, openssl
, odbcSupport ? false, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

stdenv.mkDerivation rec {
  name = "freetds-${version}";
  version = "1.00.62";

  src = fetchurl {
    url    = "http://www.freetds.org/files/stable/${name}.tar.bz2";
    sha256 = "10d1rjflp3gkmgk5zlv2ck23p0fgpxrgf1jhfv9pvy3q02h9ldis";
  };

  configureFlags = [
    "--with-tdsver=7.0"
  ];

  buildInputs = [
    openssl
  ] ++ stdenv.lib.optional odbcSupport unixODBC;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage    = http://www.freetds.org;
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
