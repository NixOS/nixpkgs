{ fetchgit, stdenv, gmp, which, flex, bison, makeWrapper
, autoconf, automake, libtool, openjdk, perl }:

stdenv.mkDerivation {
  name = "aldor-1.1.0";

  src = fetchgit {
    url = "https://github.com/pippijn/aldor";
    sha256 = "14xv3jl15ib2knsdz0bd7jx64zg1qrr33q5zcr8gli860ps8gkg3";
    rev = "f7b95835cf709654744441ddb1c515bfc2bec998";
  };

  buildInputs = [ gmp which flex bison makeWrapper autoconf automake libtool
                  openjdk perl ];

  preConfigure = ''
    cd aldor ;
    ./autogen.sh ;
  '';

  postInstall = ''
    for prog in aldor unicl javagen ;
    do
      wrapProgram $out/bin/$prog --set ALDORROOT $out \
        --prefix PATH : ${openjdk}/bin \
        --prefix PATH : ${stdenv.gcc}/bin ;
    done
  '';

  meta = {
    homepage = "http://www.aldor.org/";
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

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
