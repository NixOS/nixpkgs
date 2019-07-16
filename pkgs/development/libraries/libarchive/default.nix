{
  fetchurl, fetchpatch, stdenv, pkgconfig,
  acl, attr, bzip2, e2fsprogs, libxml2, lzo, openssl, sharutils, xz, zlib,

  # Optional but increases closure only negligibly.
  xarSupport ? true,
}:

assert xarSupport -> libxml2 != null;

stdenv.mkDerivation rec {
  name = "libarchive-${version}";
  version = "3.3.3";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    sha256 = "0bhfncid058p7n1n8v29l6wxm3mhdqfassscihbsxfwz3iwb2zms";
  };

  patches = [
    (fetchpatch {
      # details: https://github.com/libarchive/libarchive/pull/1105
      name = "cve-2018-1000877.diff"; # CVE-2018-1000877..80
      url = "https://github.com/libarchive/libarchive/pull/1105.diff";
      sha256 = "0mxcawfdy9m40mykzwhkl39a6vnh4ypgy0ipcz74qm4bi72x0gyf";
    })
    (fetchpatch {
      # details: https://github.com/libarchive/libarchive/pull/1120
      name = "cve-2019-1000019_cve-2019-1000020.diff";
      url = "https://github.com/libarchive/libarchive/pull/1120.diff";
      sha256 = "1mgx92v8hm7hw9j34nbfriqfkxshh3cy25rhavr7kl7lz4x5a6g4";
    })
  ];

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ sharutils zlib bzip2 openssl xz lzo ]
    ++ stdenv.lib.optionals stdenv.isLinux [ e2fsprogs attr acl ]
    ++ stdenv.lib.optional xarSupport libxml2;

  # Without this, pkgconfig-based dependencies are unhappy
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isLinux [ attr acl ];

  configureFlags = stdenv.lib.optional (!xarSupport) "--without-xml2";

  preBuild = if stdenv.isCygwin then ''
    echo "#include <windows.h>" >> config.h
  '' else null;

  doCheck = false; # fails

  preFixup = ''
    sed -i $lib/lib/libarchive.la \
      -e 's|-lcrypto|-L${openssl.out}/lib -lcrypto|' \
      -e 's|-llzo2|-L${lzo}/lib -llzo2|'
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Multi-format archive and compression library";
    longDescription = ''
      This library has code for detecting and reading many archive formats and
      compressions formats including (but not limited to) tar, shar, cpio, zip, and
      compressed with gzip, bzip2, lzma, xz, ...
    '';
    homepage = http://libarchive.org;
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
