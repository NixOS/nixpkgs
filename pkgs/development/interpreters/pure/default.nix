{ lib, stdenv, fetchurl, makeWrapper,
  llvm, gmp, mpfr, readline, bison, flex }:

stdenv.mkDerivation rec {
  baseName="pure";
  project="pure-lang";
  version="0.63";
  name="${baseName}-${version}";
  extension="tar.gz";

  src = fetchurl {
    url="https://bitbucket.org/purelang/${project}/downloads/${name}.${extension}";
    sha256="33acb2d560b21813f5e856973b493d9cfafba82bd6f539425ce07aa22f84ee29";
  };

  buildInputs = [ bison flex makeWrapper ];
  propagatedBuildInputs = [ llvm gmp mpfr readline ];

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