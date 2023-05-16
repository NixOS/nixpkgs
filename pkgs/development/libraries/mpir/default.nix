<<<<<<< HEAD
{ lib, stdenv, fetchurl, m4, which, yasm, autoreconfHook, fetchpatch, buildPackages }:
=======
{ lib, stdenv, fetchurl, m4, which, yasm, buildPackages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "mpir";
  version = "3.0.0";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

<<<<<<< HEAD
  nativeBuildInputs = [ m4 which yasm autoreconfHook ];
=======
  nativeBuildInputs = [ m4 which yasm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    url = "https://mpir.org/mpir-${version}.tar.bz2";
    sha256 = "1fvmhrqdjs925hzr2i8bszm50h00gwsh17p2kn2pi51zrxck9xjj";
  };

<<<<<<< HEAD
  patches = [
    # Fixes configure check failures with clang 16 due to implicit definitions of `exit`, which
    # is an error with newer versions of clang.
    (fetchpatch {
      url = "https://github.com/wbhart/mpir/commit/bbc43ca6ae0bec4f64e69c9cd4c967005d6470eb.patch";
      hash = "sha256-vW+cDK5Hq2hKEyprOJaNbj0bT2FJmMcyZHPE8GUNUWc=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  configureFlags = [ "--enable-cxx" ]
    ++ lib.optionals stdenv.isLinux [ "--enable-fat" ];

  meta = {
    description = "A highly optimised library for bignum arithmetic forked from GMP";
    license = lib.licenses.lgpl3Plus;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
    downloadPage = "https://mpir.org/downloads.html";
    homepage = "https://mpir.org/";
  };
}
