{ stdenv, fetchgit
}:

stdenv.mkDerivation rec {
  name = "liburing-${version}";
  version = "1.0.0pre132_${builtins.substring 0 7 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "f8865bc65feced660a3075175200a60968187bba";
    sha256 = "13l6s5iyrhqa0yj272qax0261cfw3nz09hq5hpf0f0kb2952d4rc";
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
