{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "libevdevc-2016-05-20";

  src = fetchFromGitHub {
    owner = "GalliumOS";
    repo = "libevdevc";
    rev = "727ac200b6f6d7c0e7e945f5845a8d0fba2b88b8";
    sha256 = "132k5iaddxw5p5dck1sjsk16piyv69iaf7qvg6wmdpafg3ilbq27";
  };

  preConfigure = ''
    substituteInPlace common.mk --replace /bin/echo echo
    substituteInPlace include/module.mk --replace /usr/include include
  '';

  installPhase = ''
    DESTDIR=$out/ LIBDIR=lib make install
  '';
}
