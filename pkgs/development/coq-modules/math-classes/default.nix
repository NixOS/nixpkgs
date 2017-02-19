{ stdenv, fetchFromGitHub, coq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-math-classes-2016-06-08";

  src = fetchFromGitHub {
    owner  = "math-classes";
    repo   = "math-classes";
    rev    = "751e63b260bd2f78b280f2566c08a18034bd40b3";
    sha256 = "0kjc2wzb6n9hcqb2ijx2pckn8jk5g09crrb87yb4s9m0mrw79smr";
  };

  buildInputs = [ coq ];
  enableParallelBuilding = true;
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://math-classes.github.io;
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with maintainers; [ siddharthist ];
    platforms = coq.meta.platforms;
  };
}
