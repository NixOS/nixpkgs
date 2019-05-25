{ stdenv, fetchgit
}:

stdenv.mkDerivation rec {
  name = "liburing-${version}";
  version = "1.0.0pre118_${builtins.substring 0 7 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "2e719820d47cdb48308265f95547d2c9458bbfe7";
    sha256 = "0sm2k5f15ad9b9wh928kmbb399f5f7frfh96bi865pklavpcckf5";
  };

  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  installFlags =
    [ "prefix=$(out)"
      "includedir=$(dev)/include"
      "libdir=$(lib)/lib"
      "mandir=$(man)/share/man"
    ];

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
