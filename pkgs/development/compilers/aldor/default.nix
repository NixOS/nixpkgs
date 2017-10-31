{ fetchgit, stdenv, gmp, which, flex, bison, makeWrapper
, autoconf, automake, libtool, jdk, perl }:

stdenv.mkDerivation {
  name = "aldor-1.2.0";

  src = fetchgit {
    url = "https://github.com/pippijn/aldor";
    sha256 = "19v07ffq4r1gjnmg7a8ifgjkwan9a3rwbj0qjz8fycwy221844m6";
    rev = "15471e75f3d65b93150f414ebcaf59a03054b68d";
  };

  buildInputs = [ gmp which flex bison makeWrapper autoconf automake libtool
                  jdk perl ];

  preConfigure = ''
    cd aldor ;
    ./autogen.sh ;
  '';

  postInstall = ''
    for prog in aldor unicl javagen ;
    do
      wrapProgram $out/bin/$prog --set ALDORROOT $out \
        --prefix PATH : ${jdk}/bin \
        --prefix PATH : ${stdenv.cc}/bin ;
    done
  '';

  meta = {
    # Please become a maintainer to fix this package
    broken = true;
    homepage = http://www.aldor.org/;
    description = "Programming language with an expressive type system";
    license = stdenv.lib.licenses.asl20;

    longDescription = ''
      Aldor is a programming language with an expressive type system well-suited
      for mathematical computing and which has been used to develop a number of
      computer algebra libraries. Originally known as A#, Aldor was conceived as
      an extension language for the Axiom system, but is now used more in other settings.
      In Aldor, types and functions are first class values that can be constructed
      and manipulated within programs. Pervasive support for dependent types allows
      static checking of dynamic objects. What does this mean for a normal user? Aldor
      solves many difficulties encountered in widely-used object-oriented programming
      languages. It allows programs to use a natural style, combining the more attractive
      and powerful properties of functional, object-oriented and aspect-oriented styles.
    '';

    platforms = stdenv.lib.platforms.linux;
  };
}
