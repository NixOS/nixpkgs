{ stdenv, fetchgit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "liburing";
  version = "0.7pre700_${builtins.substring 0 8 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/${pname}";
    rev    = "94ba6378bea8db499bedeabb54ab20fcf41555cf";
    sha256 = "1idg4jwqqhjrdn1gc843z6hdhi34v1q67n6x205h75pkax24pyig";
  };

  separateDebugInfo = true;
  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  # Don't use the default configure phase because ./configure isn't
  # an autoconf script.
  configurePhase = ''
    ./configure \
      --prefix=$out \
      --includedir=$dev/include \
      --libdir=$lib/lib \
      --mandir=$man/share/man \
      --cc=${stdenv.cc.targetPrefix}cc
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
