{ lib, stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "2.3";

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "liburing-${version}";
    sha256 = "sha256-vN6lLb5kpgHTKDxwibJPS61sdelILETVtJE2BYgp79k=";
  };

  patches = [
    # Backported portability fixes from liburing master, needed for pkgsMusl.liburing
    ./0001-Add-custom-error-function-for-tests.patch
    ./0002-test-Use-t_error-instead-of-glibc-s-error.patch
    ./0003-examples-Use-t_error-instead-of-glibc-s-error.patch

    # More portability fixes, in the process of being upstreamed
    (fetchpatch {
      url = "https://github.com/axboe/liburing/pull/798/commits/0fbcc44fe1fb2dc6807660b2cff1c2995add095b.patch";
      hash = "sha256-xOMsw0VpYGst/+Isd2Tmq8CmBDK+uyLw3KNKPnsCSoA=";
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
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
