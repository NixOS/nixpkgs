{ stdenv, fetchFromGitHub, coq_8_5 }:

let coq = coq_8_5;
in stdenv.mkDerivation {
  name = "math-classes-${coq.coq-version}";

  src = fetchFromGitHub {
    owner  = "math-classes";
    repo   = "math-classes";
    rev    = "751e63b260bd2f78b280f2566c08a18034bd40b3";
    sha256 = "0kjc2wzb6n9hcqb2ijx2pckn8jk5g09crrb87yb4s9m0mrw79smr";
  };

  buildInputs = [ coq ];
  enableParallelBuilding = true;
  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/MathClasses
    cp -pR . $COQLIB/user-contrib/MathClasses
  '';

  meta = with stdenv.lib; {
    homepage = https://math-classes.github.io;
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with maintainers; [ siddharthist ];
    platforms = coq.meta.platforms;
  };
}
