{lib, stdenv, fetchurl, sqlite}:

stdenv.mkDerivation rec
{
  version = "3.4.0";
  pname = "libzdb";

  src = fetchurl
  {
    url = "https://www.tildeslash.com/libzdb/dist/libzdb-${version}.tar.gz";
    sha256 = "sha256-q9Z1cZvL3eQwqk7hOXW5gNVdKry1zCKAgqMDIKa7nw8=";
  };

  buildInputs = [ sqlite ];

  meta =
  {
    homepage = "http://www.tildeslash.com/libzdb/";
    description = "Small, easy to use Open Source Database Connection Pool Library";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
