{stdenv, fetchurl, orc, pkgconfig}:

stdenv.mkDerivation {
  name = "schroedinger-1.0.11";

  src = fetchurl {
    urls = [
      http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz
      http://download.videolan.org/contrib/schroedinger-1.0.11.tar.gz
    ];
    sha256 = "04prr667l4sn4zx256v1z36a0nnkxfdqyln48rbwlamr6l3jlmqy";
  };

  buildInputs = [orc pkgconfig];

  # The test suite is known not to build against Orc >0.4.16 in Schroedinger 1.0.11.
  # A fix is in upstream, so test when pulling 1.0.12 if this is still needed. See:
  # http://www.mail-archive.com/schrodinger-devel@lists.sourceforge.net/msg00415.html
  preBuild = ''
    substituteInPlace Makefile \
      --replace "SUBDIRS = schroedinger doc tools testsuite" "SUBDIRS = schroedinger doc tools" \
      --replace "DIST_SUBDIRS = schroedinger doc tools testsuite" "DIST_SUBDIRS = schroedinger doc tools"
  '';

  meta = with stdenv.lib; {
    homepage = "http://diracvideo.org/";
    maintainers = [ maintainers.spwhitt ];
    license = [ licenses.mpl11 licenses.lgpl2 licenses.mit ];
    platforms = platforms.unix;
  };
}
