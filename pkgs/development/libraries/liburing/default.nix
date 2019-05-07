{ stdenv, fetchgit
}:

stdenv.mkDerivation rec {
  name = "liburing-${version}";
  version = "1.0.0pre92_${builtins.substring 0 7 src.rev}";

  src = fetchgit {
    url    = "http://git.kernel.dk/liburing";
    rev    = "7b989f34191302011b5b49bf5b26b36862d54056";
    sha256 = "12kfqvwzxksmsm8667a1g4vxr6xsaq63cz9wrfhwq6hrsv3ynydc";
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
