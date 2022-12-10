{lib, stdenv, fetchurl, sqlite}:

stdenv.mkDerivation rec
{
  version = "3.2.2";
  pname = "libzdb";

  src = fetchurl
  {
    url = "https://www.tildeslash.com/libzdb/dist/libzdb-${version}.tar.gz";
    sha256 = "1blmy7228649iscwlldrc1ldf31nhps1ps9xfv44ms0yxqhlw7nm";
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
