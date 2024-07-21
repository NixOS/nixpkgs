{ lib, stdenv, fetchurl, fetchpatch
, pkg-config
, bison, flex
, makeWrapper }:

stdenv.mkDerivation rec {

  pname = "intercal";
  version = "0.31";

  src = fetchurl {
    url = "http://catb.org/esr/intercal/${pname}-${version}.tar.gz";
    sha256 = "1z2gpa5rbqb7jscqlf258k0b0jc7d2zkyipb5csjpj6d3sw45n4k";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchains:
    #   https://gitlab.com/esr/intercal/-/issues/4
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-lang/c-intercal/files/c-intercal-31.0-no-common.patch?id=a110a98b4de6f280d770ba3cc92a4612326205a3";
      sha256 = "03523fc40042r2ryq5val27prlim8pld4950qqpawpism4w3y1p2";
    })
  ];

  nativeBuildInputs = [ pkg-config bison flex makeWrapper ];

  # Intercal invokes gcc, so we need an explicit PATH
  postInstall = ''
    wrapProgram $out/bin/ick --suffix PATH ':' ${stdenv.cc}/bin
  '';

  meta = with lib; {
    description = "Original esoteric programming language";
    longDescription = ''
      INTERCAL, an abbreviation for "Compiler Language With No
      Pronounceable Acronym", is a famously esoterical programming
      language. It was created in 1972, by Donald R. Woods and James
      M. Lyon, with the unusual goal of creating a language with no
      similarities whatsoever to any existing programming
      languages. The language largely succeeds in this goal, apart
      from its use of an assignment statement.
    '';
    homepage = "http://www.catb.org/~esr/intercal/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: investigate if LD_LIBRARY_PATH needs to be set
