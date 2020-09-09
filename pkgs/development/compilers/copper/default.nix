{ stdenv
, fetchurl
, libffi
}:
stdenv.mkDerivation rec {
  pname = "copper";
  version = "4.4";
  src = fetchurl {
    url = "https://tibleiz.net/download/copper-${version}-src.tar.gz";
    sha256 = "1nf0bw143rjhd019yms3k6k531rahl8anidwh6bif0gm7cngfwfw";
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
  meta = with stdenv.lib; {
    description = "Simple imperative language, statically typed with type inference and genericity.";
    homepage = "https://tibleiz.net/copper/";
    license = licenses.bsd2;
    platforms = platforms.x86_64;
  };
}
