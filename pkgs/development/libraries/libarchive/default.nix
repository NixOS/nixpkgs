{ fetchurl, stdenv, acl, openssl, libxml2, attr, zlib, bzip2, e2fsprogs, xz
, sharutils }:

stdenv.mkDerivation rec {
  name = "libarchive-3.1.2";

  src = fetchurl {
    urls = [
      "http://pkgs.fedoraproject.org/repo/pkgs/libarchive/libarchive-3.1.2.tar.gz/efad5a503f66329bb9d2f4308b5de98a/${name}.tar.gz"
      "${meta.homepage}/downloads/${name}.tar.gz"
    ];
    sha256 = "0pixqnrcf35dnqgv0lp7qlcw7k13620qkhgxr288v7p4iz6ym1zb";
  };

  patches = [(fetchurl {
    url = "https://github.com/libarchive/libarchive/commit/22531545514043e04633e1c015c7540b9de9dbe4.diff";
    sha256 = "1466ddrkdh2r8idmj3v7fk2gwnhc1kdxvyczdpnqms0qlmas6fj5";
    name = "CVE-2013-0211.patch";
  })];

  buildInputs = [ sharutils libxml2 zlib bzip2 openssl xz ] ++
    stdenv.lib.optionals stdenv.isLinux [ e2fsprogs attr acl ];

  meta = {
    description = "Multi-format archive and compression library";
    longDescription = ''
      This library has code for detecting and reading many archive formats and
      compressions formats including (but not limited to) tar, shar, cpio, zip, and
      compressed with gzip, bzip2, lzma, xz, .. 
    '';
    homepage = http://libarchive.org;
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
