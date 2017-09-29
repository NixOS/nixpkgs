{ stdenv, fetchurl, coq }:

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-math-classes-1.0.6";

  src = fetchurl {
    url = https://github.com/math-classes/math-classes/archive/1.0.6.tar.gz;
    sha256 = "071hgjk4bz2ybci7dp2mw7xqmxmm2zph7kj28xcdg28iy796lf02";
  };

  # src = fetchFromGitHub {
  #   owner  = "math-classes";
  #   repo   = "math-classes";
  #   rev    = "1d426a08c2fbfd68bd1b3622fe8f31dd03712e6c";
  #   sha256 = "3kjc2wzb6n9hcqb2ijx2pckn8jk5g09crrb87yb4s9m0mrw79smr";
  # };

  buildInputs = [ coq ];
  enableParallelBuilding = true;
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://math-classes.github.io;
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with maintainers; [ siddharthist jwiegley ];
    platforms = coq.meta.platforms;
  };
}
