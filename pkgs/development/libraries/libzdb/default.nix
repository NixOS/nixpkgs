{stdenv, fetchurl, sqlite}:

stdenv.mkDerivation rec
{
  version = "3.1";
  name = "libzdb-${version}";

  src = fetchurl
  {
    url = "https://www.tildeslash.com/libzdb/dist/libzdb-${version}.tar.gz";
    sha256 = "1596njvy518x7vsvsykmnk1ky82x8jxd6nmmp551y6hxn2qsn08g";
  };

  buildInputs = [ sqlite ];

  meta =
  {
    homepage = http://www.tildeslash.com/libzdb/;
    description = "A small, easy to use Open Source Database Connection Pool Library";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
