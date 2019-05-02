{ stdenv, fetchgit
}:

stdenv.mkDerivation rec {
  name = "liburing-${version}";
  version = "1.0.0pre821_${builtins.substring 0 7 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "39e0ebd4fc66046bf733a47aaa899a556093ebc6";
    sha256 = "00c72fizxmwxd2jzmlzi4l82cw7h75lfpkkwzwcjpw9zdg9w0ci7";
  };

  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  installFlags =
    [ "prefix=$(out)"
      "includedir=$(dev)/include"
      "libdir=$(lib)/lib"
    ];

  # Copy the examples into $out and man pages into $man. This should be handled
  # by the build system in the future and submitted upstream.
  postInstall = ''
    mkdir -p $out/bin $man/share/man/man2/
    cp -R ./man/* $man/share/man/man2
    cp ./examples/io_uring-cp examples/io_uring-test $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Userspace library for the Linux io_uring API";
    homepage    = http://git.kernel.dk/cgit/liburing/;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
    badPlatforms = [ "aarch64-linux" ];
  };
}
