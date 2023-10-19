{ lib, stdenv, fetchgit, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "2.4";

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "liburing-${version}";
    sha256 = "sha256-vbe9uh9AqXyPkzwD6zHoHH3JMeAJEl2FSGzny1T7diM=";
  };

  patches = [
    # Pull upstream fix for parallel build failures:
    #   https://github.com/axboe/liburing/pull/891
    (fetchpatch {
      name = "parallel.patch";
      url = "https://github.com/axboe/liburing/commit/c34dca74854cb6e7f2b09affa2a4ab0145e62371.patch";
      hash = "sha256-RZSgHdQy5d7mXtMvkMyr+/kMhp1w+S5v9cqk5NSii5o=";
    })
  ];

  separateDebugInfo = true;
  enableParallelBuilding = true;
  # Upstream's configure script is not autoconf generated, but a hand written one.
  setOutputFlags = false;
  configureFlags = [
    "--includedir=${placeholder "dev"}/include"
    "--mandir=${placeholder "man"}/share/man"
  ];

  # Doesn't recognize platform flags
  configurePlatforms = [];

  outputs = [ "out" "bin" "dev" "man" ];

  postInstall = ''
    # Copy the examples into $bin. Most reverse dependency of this package should
    # reference only the $out output
    mkdir -p $bin/bin
    cp ./examples/io_uring-cp examples/io_uring-test $bin/bin
    cp ./examples/link-cp $bin/bin/io_uring-link-cp
  '' + lib.optionalString stdenv.hostPlatform.isGnu ''
    cp ./examples/ucontext-cp $bin/bin/io_uring-ucontext-cp
  '';

  meta = with lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = "https://git.kernel.dk/cgit/liburing/";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice nickcao ];
  };
}
