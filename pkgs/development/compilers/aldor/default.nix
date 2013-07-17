{ fetchgit, stdenv, gmp, which, flex, bison, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "aldor";
  version = "1.1.0";
  name = "${pname}-${version}";
  gitRev = "a02b088c8d5d06f16c50a83ddee4019e962d6673";

  src = fetchgit {
    url = "https://github.com/pippijn/aldor";
    sha256 = "1zd343wq46f74yr30a5nrbv5n831z6wd24yqnrs7w17ccic69lny";
    rev = gitRev;
  };

  buildInputs = [ gmp which flex bison makeWrapper ];

  installPhase = ''
    for d in bin include lib ;
    do
      ensureDir $out/$d ;
      cp -r build/$d $out/ ;
    done

    for prog in aldor unicl zacc ;
    do
      wrapProgram $out/bin/$prog --set ALDORROOT $out \
        --prefix PATH : ${stdenv.gcc}/bin ;
    done
  '';

  meta = with stdenv.lib ; {
    description = "Aldor is a programming language with an expressive type system";

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

    homepage = http://www.aldor.org/;
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
