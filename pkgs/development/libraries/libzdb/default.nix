{lib, stdenv, fetchurl, sqlite}:

stdenv.mkDerivation rec
{
  version = "3.2.3";
  pname = "libzdb";

  src = fetchurl
  {
    url = "https://www.tildeslash.com/libzdb/dist/libzdb-${version}.tar.gz";
    sha256 = "sha256-oZV4Jvq3clSE/Ft0eApqfQ2Lf14uVNJuEGs5ngqGvrA=";
  };

  buildInputs = [ sqlite ];

  meta =
  {
    homepage = "http://www.tildeslash.com/libzdb/";
    description = "A small, easy to use Open Source Database Connection Pool Library";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
