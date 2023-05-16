<<<<<<< HEAD
{ lib, stdenv, fetchgit, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "2.4";
=======
{ lib, stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "liburing-${version}";
<<<<<<< HEAD
    sha256 = "sha256-vbe9uh9AqXyPkzwD6zHoHH3JMeAJEl2FSGzny1T7diM=";
  };

  patches = [
    # Pull upstream fix for parallel build failures:
    #   https://github.com/axboe/liburing/pull/891
    (fetchpatch {
      name = "parallel.patch";
      url = "https://github.com/axboe/liburing/commit/c34dca74854cb6e7f2b09affa2a4ab0145e62371.patch";
      hash = "sha256-RZSgHdQy5d7mXtMvkMyr+/kMhp1w+S5v9cqk5NSii5o=";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  separateDebugInfo = true;
  enableParallelBuilding = true;
  # Upstream's configure script is not autoconf generated, but a hand written one.
  setOutputFlags = false;
<<<<<<< HEAD
  configureFlags = [
    "--includedir=${placeholder "dev"}/include"
    "--mandir=${placeholder "man"}/share/man"
  ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ thoughtpolice nickcao ];
=======
    maintainers = with maintainers; [ thoughtpolice ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
