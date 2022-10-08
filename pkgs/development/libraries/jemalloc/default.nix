{ lib
, stdenv
, fetchurl
, fetchpatch
# By default, jemalloc puts a je_ prefix onto all its symbols on OSX, which
# then stops downstream builds (mariadb in particular) from detecting it. This
# option should remove the prefix and give us a working jemalloc.
# Causes segfaults with some software (ex. rustc), but defaults to true for backward
# compatibility.
, stripPrefix ? stdenv.hostPlatform.isDarwin
, disableInitExecTls ? false
}:

stdenv.mkDerivation rec {
  pname = "jemalloc";
  version = "5.2.1";

  src = fetchurl {
    url = "https://github.com/jemalloc/jemalloc/releases/download/${version}/${pname}-${version}.tar.bz2";
    sha256 = "1xl7z0vwbn5iycg7amka9jd6hxd8nmfk7nahi4p9w2bnw9f0wcrl";
  };

  patches = [
    # workaround https://github.com/jemalloc/jemalloc/issues/2091
    (fetchpatch {
      url = "https://github.com/jemalloc/jemalloc/commit/3b4a03b92b2e415415a08f0150fdb9eeb659cd52.diff";
      sha256 = "sha256-6AYtADREhfj93ZLk9xnXtjc6vHDU0EKLLOvLd6YdJeI=";
    })
  ];

  # see the comment on stripPrefix
  configureFlags = []
    ++ lib.optional stripPrefix "--with-jemalloc-prefix="
    ++ lib.optional disableInitExecTls "--disable-initial-exec-tls"
    # jemalloc is unable to correctly detect transparent hugepage support on
    # ARM (https://github.com/jemalloc/jemalloc/issues/526), and the default
    # kernel ARMv6/7 kernel does not enable it, so we explicitly disable support
    ++ lib.optionals (stdenv.isAarch32 && lib.versionOlder version "5") [
      "--disable-thp"
      "je_cv_thp=no"
    ]
    # See https://github.com/jemalloc/jemalloc/issues/1997
    # Using a value of 48 should work on both emulated and native x86_64-darwin.
    ++ lib.optional (stdenv.isDarwin && stdenv.isx86_64) "--with-lg-vaddr=48"
  ;

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://jemalloc.net";
    description = "General purpose malloc(3) implementation";
    longDescription = ''
      malloc(3)-compatible memory allocator that emphasizes fragmentation
      avoidance and scalable concurrency support.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
