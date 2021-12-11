{ lib, stdenv
, fetchurl
, libffi
}:
stdenv.mkDerivation rec {
  pname = "copper";
  version = "4.5";
  src = fetchurl {
    url = "https://tibleiz.net/download/copper-${version}-src.tar.gz";
    sha256 = "sha256-Evrzin7JMhr5Q3m/k+9KpW9++rXzlL78TVGjeOtWfYw=";
  };
  buildInputs = [
    libffi
  ];
  postPatch = ''
    substituteInPlace Makefile --replace "-s scripts/" "scripts/"
    patchShebangs .
  '';
  buildPhase = ''
    make BACKEND=elf64 boot-elf64
    make BACKEND=elf64 COPPER=stage3/copper-elf64 copper-elf64
  '';
  installPhase = ''
    make BACKEND=elf64 install prefix=$out
  '';
  meta = with lib; {
    description = "Simple imperative language, statically typed with type inference and genericity";
    homepage = "https://tibleiz.net/copper/";
    license = licenses.bsd2;
    platforms = platforms.x86_64;
    broken = stdenv.isDarwin;
  };
}
