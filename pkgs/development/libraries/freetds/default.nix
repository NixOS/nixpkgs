{ stdenv, fetchurl, autoreconfHook, pkgconfig
, openssl
, odbcSupport ? true, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

# Work is in progress to move to cmake so revisit that later

stdenv.mkDerivation rec {
  pname = "freetds";
  version = "1.2";

  src = fetchurl {
    url    = "https://www.freetds.org/files/stable/${pname}-${version}.tar.bz2";
    sha256 = "0nilqf3cssi6z8bxxpmc7zxsh7apgwmx8mm7nfc6c5d40z3nyjpk";
  };

  buildInputs = [
    openssl
  ] ++ stdenv.lib.optional odbcSupport unixODBC;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage    = "https://www.freetds.org";
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
