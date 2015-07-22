{ lib, stdenv, fetchurl, makeWrapper,
  llvm, gmp, mpfr, readline, bison, flex }:

stdenv.mkDerivation rec {
  baseName="pure";
  project="pure-lang";
  version="0.64";
  name="${baseName}-${version}";
  extension="tar.gz";

  src = fetchurl {
    url="https://bitbucket.org/purelang/${project}/downloads/${name}.${extension}";
    sha256="01vvix302gh5vsmnjf2g0rrif3hl1yik4izsx1wrvv1a6hlm5mgg";
  };

  buildInputs = [ bison flex makeWrapper ];
  propagatedBuildInputs = [ llvm gmp mpfr readline ];

  postPatch = ''
    for f in expr.cc matcher.cc printer.cc symtable.cc parserdefs.hh; do
      sed -i '1i\#include <stddef.h>' $f
    done
  '';

  configureFlags = [ "--enable-release" ];
  doCheck = true;
  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${llvm}/lib make check
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
  };
}
