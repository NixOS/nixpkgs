{stdenv, fetchurl, sqlite}:

stdenv.mkDerivation rec
{
  version = "3.0";
  name = "libzdb-${version}";

  src = fetchurl
  {
    url = "http://www.tildeslash.com/libzdb/dist/libzdb-${version}.tar.gz";
    sha256 = "e334bcb9ca1410e863634a164e3b1b5784018eb6e90b6c2b527780fc29a123c8";
  };

  buildInputs = [ sqlite ];

  meta =
  {
    homepage = "http://www.tildeslash.com/libzdb/";
    description = "A small, easy to use Open Source Database Connection Pool Library.";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}