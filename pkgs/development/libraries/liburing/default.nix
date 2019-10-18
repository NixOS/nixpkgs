{ stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "0.2pre246_${builtins.substring 0 8 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "08bd815170ab4352d71019f4d3e532cd3f6f0489";
    sha256 = "1wqraxj9mzph3wgfq4ld4bxa8ya2db65cwzyh9fmhvhhlsivi6wr";
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
    homepage    = http://git.kernel.dk/cgit/liburing/;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
