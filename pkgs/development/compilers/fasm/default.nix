{ stdenv, lib, fasm-bin, isx86_64 }:

stdenv.mkDerivation {
  inherit (fasm-bin) version src meta;

  pname = "fasm";

  nativeBuildInputs = [ fasm-bin ];

  buildPhase = ''
    fasm source/Linux${lib.optionalString isx86_64 "/x64"}/fasm.asm fasm
    for tool in listing prepsrc symbols; do
      fasm tools/libc/$tool.asm
      cc -o tools/libc/fasm-$tool tools/libc/$tool.o
    done
  '';

  outputs = [ "out" "doc" ];

  installPhase = ''
    install -Dt $out/bin fasm tools/libc/fasm-*

    docs=$doc/share/doc/fasm
    mkdir -p $docs
    cp -r examples/ *.txt tools/fas.txt $docs
    cp tools/readme.txt $docs/tools.txt
  '';
}
