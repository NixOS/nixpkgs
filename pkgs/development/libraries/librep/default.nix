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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "librep";
  version = "0.92.7";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://download.tuxfamily.org/librep/librep_${finalAttrs.version}.tar.xz";
    hash = "sha256-SKGWeax8BTCollfeGP/knFdZpf9w/IRJKLDl0AOVrK4=";
=======
    url = "https://download.tuxfamily.org/${pname}/${pname}_${version}.tar.xz";
    sha256 = "1bmcjl1x1rdh514q9z3hzyjmjmwwwkziipjpjsl301bwmiwrd8a8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    gdbm
    gmp
    libffi
    readline
  ];

<<<<<<< HEAD
  strictDeps = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # ensure libsystem/ctype functions don't get duplicated when using clang
  configureFlags = lib.optionals stdenv.isDarwin [ "CFLAGS=-std=gnu89" ];

  setupHook = ./setup-hook.sh;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib;{
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "http://sawfish.tuxfamily.org/";
    description = "Fast, lightweight, and versatile Lisp environment";
    longDescription = ''
      librep is a Lisp system for UNIX, comprising an interpreter, a byte-code
      compiler, and a virtual machine. It can serve as an application extension
      language but is also suitable for standalone scripts.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# TODO: investigate fetchFromGithub
