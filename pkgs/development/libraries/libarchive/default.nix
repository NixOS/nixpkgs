{ fetchurl, stdenv, acl, openssl, libxml2, attr, zlib, bzip2, e2fsprogs, xz
, sharutils }:

stdenv.mkDerivation rec {
  name = "libarchive-3.0.4";

  src = fetchurl {
    url = "https://github.com/downloads/libarchive/libarchive/${name}.tar.gz";
    sha256 = "76e8d7c7b100ec4071e48c1b7d3f3ea1d22b39db3e45b7189f75b5ff4df90fac";
  };

  propagatedBuildInputs = [ libxml2 zlib bzip2 openssl xz ] ++
    stdenv.lib.optionals stdenv.isLinux [ e2fsprogs attr acl ];

  buildInputs = [ sharutils ];

  meta = {
    description = "Multi-format archive and compression library";
    longDescription = ''
      This library has code for detecting and reading many archive formats and
      compressions formats including (but not limited to) tar, shar, cpio, zip, and
      compressed with gzip, bzip2, lzma, xz, .. 
    '';
    homepage = http://libarchive.github.com/;
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
