{ lib, stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "2.1"; # remove patch when updating

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "liburing-${version}";
    sha256 = "sha256-7wSpKqjIdQeOdsQu4xN3kFHV49n6qQ3xVbjUcY1tmas=";
  };

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

  # fix for compilation on 32-bit ARM, merged by upstream but not released; remove when
  # upstream releases an update
  patches = lib.optional stdenv.isAarch32 [
    (fetchpatch {
      url = "https://github.com/axboe/liburing/commit/e75a6cfa085fc9b5dbf5140fc1efb5a07b6b829e.diff";
      sha256 = "sha256-qQEQXYm5mkws2klLxwuuoPSPRkpP1s6tuylAAEp7+9E=";
    })
  ];

  meta = with lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = "https://git.kernel.dk/cgit/liburing/";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
