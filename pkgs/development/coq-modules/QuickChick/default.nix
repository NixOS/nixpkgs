{stdenv, fetchgit, coq, coqPackages}:

let revision = "04785ee692036e7ba9f4c4e380b1995128a97bf8"; in

stdenv.mkDerivation rec {

  name = "coq-QuickChick-${coq.coq-version}-${version}";
  version = "20170422-${builtins.substring 0 7 revision}";

  src = fetchgit {
    url = git://github.com/QuickChick/QuickChick.git;
    rev = revision;
    sha256 = "1x5idk9d9r5mj1w54676a5j92wr1id7c9dmknkpmnh78rgrqzy5j";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq coqPackages.ssreflect ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = git://github.com/QuickChick/QuickChick.git;
    description = "Randomized property-based testing plugin for Coq; a clone of Haskell QuickCheck";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
