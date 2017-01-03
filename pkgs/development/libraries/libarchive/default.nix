{ fetchurl, stdenv, pkgconfig
, acl, attr, bzip2, e2fsprogs, sharutils, xz, zlib

  # Optional but increases closure only negligibly.
, withLzo ? true, lzo ? null
, withOpenssl ? true, openssl ? null
, xarSupport ? true, libxml2 ? null
}:

with stdenv.lib;

assert withLzo -> lzo != null;
assert withOpenssl -> openssl != null;
assert xarSupport -> libxml2 != null;

stdenv.mkDerivation rec {
  name = "libarchive-${version}";
  version = "3.2.2";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    sha256 = "03q6y428rg723c9fj1vidzjw46w1vf8z0h95lkvz1l9jw571j739";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ sharutils zlib bzip2 xz ]
    ++ optionals stdenv.isLinux [ e2fsprogs attr acl ]
    ++ optional withLzo lzo
    ++ optional withOpenssl openssl
    ++ optional xarSupport libxml2;

  # Without this, pkgconfig-based dependencies are unhappy
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isLinux [ attr acl ];

  configureFlags = []
    ++ optional (!withLzo) "--without-lzo"
    ++ optional (!withOpenssl) "--without-openssl"
    ++ optional (!xarSupport) "--without-xml2";

  preBuild = optionalString stdenv.isCygwin ''
    echo "#include <windows.h>" >> config.h
  '';

  preFixup = ''
  '' + optionalString withLzo ''
    sed -i $lib/lib/libarchive.la \
      -e 's|-llzo2|-L${lzo}/lib -llzo2|'
  '' + optionalString withOpenssl ''
    sed -i $lib/lib/libarchive.la \
      -e 's|-lcrypto|-L${openssl.out}/lib -lcrypto|
  '';

  meta = {
    description = "Multi-format archive and compression library";
    longDescription = ''
      This library has code for detecting and reading many archive formats and
      compressions formats including (but not limited to) tar, shar, cpio, zip, and
      compressed with gzip, bzip2, lzma, xz, ...
    '';
    homepage = http://libarchive.org;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ jcumming lnl7 ];
  };
}
