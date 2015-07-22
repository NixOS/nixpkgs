{stdenv, fetchgit, coq, coqPackages}:

stdenv.mkDerivation rec {

  name = "coq-QuickChick-${coq.coq-version}-${version}";
  version = "21f50a02";

  src = fetchgit {
    url = git://github.com/QuickChick/QuickChick.git;
    rev = "21f50a02e752f6d99d5bfefefcd2ad45df5e778a";
    sha256 = "15hsirm443cr098hksfcg3nbjm9mdnmxzpz61qq7ap7lglabl7pw";
  };

  buildInputs = [ coq.ocaml coq.camlp5 coqPackages.ssreflect ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = git://github.com/QuickChick/QuickChick.git;
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
