{stdenv, fetchurl, sqlite}:

stdenv.mkDerivation rec
{
  version = "3.2.1";
  pname = "libzdb";

  src = fetchurl
  {
    url = "https://www.tildeslash.com/libzdb/dist/libzdb-${version}.tar.gz";
    sha256 = "1w9zzpgw3qzirsy5g4aaq1469kdq46gr2nhvrs3xqlwz1adbb9xr";
  };

  buildInputs = [ sqlite ];

  meta =
  {
    homepage = "http://www.tildeslash.com/libzdb/";
    description = "A small, easy to use Open Source Database Connection Pool Library";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
