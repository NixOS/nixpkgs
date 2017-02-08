{
  fetchurl, stdenv, pkgconfig,
  acl, attr, bzip2, e2fsprogs, libxml2, lzo, openssl, sharutils, xz, zlib,

  # Optional but increases closure only negligibly.
  xarSupport ? true,
}:

assert xarSupport -> libxml2 != null;

stdenv.mkDerivation rec {
  name = "libarchive-${version}";
  version = "3.2.2";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    sha256 = "03q6y428rg723c9fj1vidzjw46w1vf8z0h95lkvz1l9jw571j739";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/libarchive/libarchive/commit/98dcbbf0bf4854bf987557e55e55fff7abbf3ea9.patch";
      sha256 = "1934krf5imc9rq1av6immpsfn77pglanhz1csq8j22h9ab87n5z6";
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

  preFixup = ''
    sed -i $lib/lib/libarchive.la \
      -e 's|-lcrypto|-L${openssl.out}/lib -lcrypto|' \
      -e 's|-llzo2|-L${lzo}/lib -llzo2|'
  '';

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
