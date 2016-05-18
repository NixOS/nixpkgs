{ fetchurl, stdenv, acl, openssl, libxml2, attr, zlib, bzip2, e2fsprogs, xz, lzo
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

  patches = [
    ./CVE-2013-0211.patch # https://github.com/libarchive/libarchive/commit/22531545
    ./CVE-2015-1197.patch # https://github.com/NixOS/nixpkgs/issues/6799
      # ^ it's CVE-2015-2304 specific to libarchive
  ];

  buildInputs = [ sharutils libxml2 zlib bzip2 openssl xz lzo ] ++
    stdenv.lib.optionals stdenv.isLinux [ e2fsprogs attr acl ];

  # Without this, pkgconfig-based dependencies are unhappy
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isLinux [ attr acl ];

  preBuild = if stdenv.isCygwin then ''
    echo "#include <windows.h>" >> config.h
  '' else null;

  preFixup = ''
    sed -i $out/lib/libarchive.la \
      -e 's|-lcrypto|-L${openssl.out}/lib -lcrypto|' \
      -e 's|-llzo2|-L${lzo}/lib -llzo2|'
  '';

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
