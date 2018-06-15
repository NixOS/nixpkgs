{
  fetchurl, fetchpatch, stdenv, pkgconfig,
  acl, attr, bzip2, e2fsprogs, libxml2, lzo, openssl, sharutils, xz, zlib,

  # Optional but increases closure only negligibly.
  xarSupport ? true,
}:

assert xarSupport -> libxml2 != null;

stdenv.mkDerivation rec {
  name = "libarchive-${version}";
  version = "3.3.2";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${name}.tar.gz";
    sha256 = "1km0mzfl6in7l5vz9kl09a88ajx562rw93ng9h2jqavrailvsbgd";
  };

  patches = [
    ./CVE-2017-14166.patch
    ./CVE-2017-14502.patch

    # LibreSSL patch; this is from upstream, and can be removed when the next release is made.
    (fetchpatch {
      url = "https://github.com/libarchive/libarchive/commit/5da00ad75b09e262774ec3675bbe4d5a4502a852.patch";
      sha256 = "0np1i9r6mfxmbksj7mmf5abpnmlmg63704p9z3ihjh2rnq596c1v";
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
