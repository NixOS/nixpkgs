{ stdenv, fetchgit
}:

stdenv.mkDerivation rec {
  name = "liburing-${version}";
  version = "1.0.0pre116_${builtins.substring 0 7 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "ffe3e090cd41d0977ca74fafcb452838f76ceea1";
    sha256 = "1nmg89jgz1kbv7lv1drkkb4x0pank51sijagflxmnmvqgrk53gxd";
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
