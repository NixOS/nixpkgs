{ stdenv, fetchurl
, pkgconfig
, bison, flex
, makeWrapper }:

with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "intercal";
  version = "0.30";

  src = fetchurl {
    url = "http://catb.org/esr/intercal/${pname}-${version}.tar.gz";
    sha256 = "058ppvvgz9r5603ia9jkknbrciypgg4hjbczrv9v1d9w3ak652xk";
  };

  buildInputs =
  [ pkgconfig bison flex makeWrapper ];

  # Intercal invokes gcc, so we need an explicit PATH
  postInstall = ''
    wrapProgram $out/bin/ick --suffix PATH ':' ${stdenv.cc}/bin
  '';

  meta = {
    description = "The original esoteric programming language";
    longDescription = ''
      INTERCAL, an abbreviation for "Compiler Language With No
      Pronounceable Acronym", is a famously esoterical programming
      language. It was created in 1972, by Donald R. Woods and James
      M. Lyon, with the unusual goal of creating a language with no
      similarities whatsoever to any existing programming
      languages. The language largely succeeds in this goal, apart
      from its use of an assignment statement.
    '';
    homepage = http://www.catb.org/~esr/intercal/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: investigate if LD_LIBRARY_PATH needs to be set
