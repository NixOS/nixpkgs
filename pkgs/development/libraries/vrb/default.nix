{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vrb";
  version = "0.5.1";

  src = fetchurl {
    url = "http://vrb.sourceforge.net/download/${pname}-${version}.tar.bz2";
    sha256 = "d579ed1998ef2d78e2ef8481a748d26e1fa12cdda806d2e31d8ec66ffb0e289f";
  };

  patches = [
    ./removed_options.patch
    ./unused-but-set-variable.patch
  ];

  postPatch = ''
    patchShebangs configure
  '';

  postInstall = ''
    mkdir -p $out/share/man/man3
    cp -p vrb/man/man3/*.3 $out/share/man/man3/
  '';

  meta = with lib; {
    description = "A virtual ring buffer library written in C";
    mainProgram = "vbuf";
    license     = licenses.lgpl21;
    homepage    = "http://vrb.sourceforge.net/";
    maintainers = [ maintainers.bobvanderlinden ];
    platforms   = platforms.linux;
  };
}

