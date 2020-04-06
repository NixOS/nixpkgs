{ lib, stdenv, fetchurl, makeWrapper,
  llvm, gmp, mpfr, readline, bison, flex }:

stdenv.mkDerivation rec {
  baseName="pure";
  version="0.68";
  name="${baseName}-${version}";

  src = fetchurl {
    url="https://github.com/agraef/pure-lang/releases/download/${name}/${name}.tar.gz";
    sha256="0px6x5ivcdbbp2pz5n1r1cwg1syadklhjw8piqhl63n91i4r7iyb";
  };

  buildInputs = [ bison flex makeWrapper ];
  propagatedBuildInputs = [ llvm gmp mpfr readline ];
  NIX_LDFLAGS = "-lLLVMJIT";

  postPatch = ''
    for f in expr.cc matcher.cc printer.cc symtable.cc parserdefs.hh; do
      sed -i '1i\#include <stddef.h>' $f
    done
  '';

  configureFlags = [ "--enable-release" ];
  doCheck = true;
  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${llvm}/lib make check
  '';
  postInstall = ''
    wrapProgram $out/bin/pure --prefix LD_LIBRARY_PATH : ${llvm}/lib
  '';

  meta = {
    description = "A modern-style functional programming language based on term rewriting";
    maintainers = with lib.maintainers;
    [
      raskin
      asppsa
    ];
    platforms = with lib.platforms;
      linux;
    license = lib.licenses.gpl3Plus;
    broken = true;
  };
}
