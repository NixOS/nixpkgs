{ lib
, stdenv
, fetchurl
, autoreconfHook
, gdbm
, gmp
, libffi
, pkg-config
, readline
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "librep";
  version = "0.92.7";

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/${pname}_${version}.tar.xz";
    sha256 = "1bmcjl1x1rdh514q9z3hzyjmjmwwwkziipjpjsl301bwmiwrd8a8";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];
  buildInputs = [
    gdbm
    gmp
    libffi
    readline
  ];

  # ensure libsystem/ctype functions don't get duplicated when using clang
  configureFlags = lib.optionals stdenv.isDarwin [ "CFLAGS=-std=gnu89" ];

  setupHook = ./setup-hook.sh;

  meta = with lib;{
    homepage = "http://sawfish.tuxfamily.org/";
    description = "Fast, lightweight, and versatile Lisp environment";
    longDescription = ''
      librep is a Lisp system for UNIX, comprising an interpreter, a byte-code
      compiler, and a virtual machine. It can serve as an application extension
      language but is also suitable for standalone scripts.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: investigate fetchFromGithub
