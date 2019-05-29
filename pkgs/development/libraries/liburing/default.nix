{ stdenv, fetchgit
}:

stdenv.mkDerivation rec {
  name = "liburing-${version}";
  version = "1.0.0pre131_${builtins.substring 0 7 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "b422aa11cc58e9786fa1e343aa2bfa6d7a394445";
    sha256 = "0afm0kfhi025m5r0bri8if59m85rwg6kxlkx075lbwg9pw1n75w0";
  };

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
