{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "jemalloc-${version}";
  version = "5.0.1";

  src = fetchurl {
    url = "https://github.com/jemalloc/jemalloc/releases/download/${version}/${name}.tar.bz2";
    sha256 = "4814781d395b0ef093b21a08e8e6e0bd3dab8762f9935bbfb71679b0dea7c3e9";
  };

  # By default, jemalloc puts a je_ prefix onto all its symbols on OSX, which
  # then stops downstream builds (mariadb in particular) from detecting it. This
  # option should remove the prefix and give us a working jemalloc.
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--with-jemalloc-prefix="
                   # jemalloc is unable to correctly detect transparent hugepage support on
                   # ARM (https://github.com/jemalloc/jemalloc/issues/526), and the default
                   # kernel ARMv6/7 kernel does not enable it, so we explicitly disable support
                   ++ stdenv.lib.optional stdenv.isAarch32 "--disable-thp";
  doCheck = true;

  patches = stdenv.lib.optional stdenv.isAarch64 (fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/jemalloc/jemalloc/pull/1035.patch";
    sha256 = "02y0q3dp253bipxv4r954nqipbjbj92p6ww9bx5bk3d8pa81wkqq";
  });

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://jemalloc.net;
    description = "General purpose malloc(3) implementation";
    longDescription = ''
      malloc(3)-compatible memory allocator that emphasizes fragmentation
      avoidance and scalable concurrency support.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
