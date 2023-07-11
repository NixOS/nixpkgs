{ lib
, stdenv
, fetchurl
, libffi
}:
stdenv.mkDerivation rec {
  pname = "copper";
  version = "4.6";
  src = fetchurl {
    url = "https://tibleiz.net/download/copper-${version}-src.tar.gz";
    sha256 = "sha256-tyxAMJp4H50eBz8gjt2O3zj5fq6nOIXKX47wql8aUUg=";
  };
  buildInputs = [
    libffi
  ];
  postPatch = ''
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
    broken = true;
  };
}
