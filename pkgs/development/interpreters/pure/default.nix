{ lib, stdenv, fetchurl, makeWrapper,
  llvm, gmp, mpfr, readline, bison, flex }:

stdenv.mkDerivation rec {
  baseName="pure";
  project="pure-lang";
  version="0.62";
  name="${baseName}-${version}";
  extension="tar.gz";

  src = fetchurl {
    url="https://bitbucket.org/purelang/${project}/downloads/${name}.${extension}";
    sha256="77df64e8154ef6f8fac66f8bcc471dc8f994862d1ee77b7c98003607757a013b";
  };

  buildInputs = [ bison flex makeWrapper ];
  propagatedBuildInputs = [ llvm gmp mpfr readline ];

  postInstall = ''
    wrapProgram $out/bin/pure --prefix LD_LIBRARY_PATH : ${llvm}/lib
  '';

  meta = {
    description = "A modern-style functional programming language based on term rewriting";
    maintainers = with lib.maintainers;
    [
      raskin
    ];
    platforms = with lib.platforms;
      linux;
    license = lib.licenses.gpl3Plus;
  };
}