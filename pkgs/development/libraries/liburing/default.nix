{ lib, stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "2.0";

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "liburing-${version}";
    sha256 = "0has1yd1ns5q5jgcmhrbgwhbwq0wix3p7xv3dyrwdf784p56izkn";
  };

  patches = [
    # Fix build on 32-bit ARM
    (fetchpatch {
      url = "https://github.com/axboe/liburing/commit/808b6c72ab753bda0c300b5683cfd31750d1d49b.patch";
      sha256 = "1x7a9c5a6rwhfsbjqmhbnwh2aiin6yylckrqdjbzljrprzf11wrd";
    })
  ];

  separateDebugInfo = true;
  enableParallelBuilding = true;
  # Upstream's configure script is not autoconf generated, but a hand written one.
  setOutputFlags = false;
  preConfigure =
    # We cannot use configureFlags or configureFlagsArray directly, since we
    # don't have structuredAttrs yet and using placeholder causes permissions
    # denied errors. Using $dev / $man in configureFlags causes bash evaluation
    # errors
  ''
    configureFlagsArray+=(
      "--includedir=$dev/include"
      "--mandir=$man/share/man"
    )
  '';

  # Doesn't recognize platform flags
  configurePlatforms = [];

  outputs = [ "out" "bin" "dev" "man" ];

  postInstall =
  # Copy the examples into $bin. Most reverse dependency of this package should
  # reference only the $out output
  ''
    mkdir -p $bin/bin
    cp ./examples/io_uring-cp examples/io_uring-test $bin/bin
    cp ./examples/link-cp $bin/bin/io_uring-link-cp
    cp ./examples/ucontext-cp $bin/bin/io_uring-ucontext-cp
  ''
  ;

  meta = with lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = "https://git.kernel.dk/cgit/liburing/";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
