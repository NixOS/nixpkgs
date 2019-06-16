{ stdenv, fetchgit
}:

stdenv.mkDerivation rec {
  name = "liburing-${version}";
  version = "1.0.0pre137_${builtins.substring 0 7 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "91dde5c956b1af491bc6c16ee230daa4b4b66706";
    sha256 = "0rk1ikrn3s6sp3gx7kc4y6msx7yncr3845m67vhk8lxvhd90sgza";
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
  '';

  meta = with stdenv.lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = http://git.kernel.dk/cgit/liburing/;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
