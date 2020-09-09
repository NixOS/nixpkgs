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

  outputs = [ "out" "lib" "dev" "man" ];

  configurePhase = ''
    ./configure \
      --prefix=$out \
      --includedir=$dev/include \
      --libdir=$lib/lib \
      --mandir=$man/share/man \
  '';

  # Copy the examples into $out.
  postInstall = ''
    mkdir -p $out/bin
    cp ./examples/io_uring-cp examples/io_uring-test $out/bin
    cp ./examples/link-cp $out/bin/io_uring-link-cp
    cp ./examples/ucontext-cp $out/bin/io_uring-ucontext-cp
  '';

  meta = with stdenv.lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = "https://git.kernel.dk/cgit/liburing/";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
