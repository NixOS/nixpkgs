{ stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "0.7";

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "liburing-${version}";
    sha256 = "15z44l7y4c6s6dlf7v8lq4znlsjbja2r4ifbni0l8cdcnq0w3zh3";
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

  meta = with stdenv.lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = "https://git.kernel.dk/cgit/liburing/";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
