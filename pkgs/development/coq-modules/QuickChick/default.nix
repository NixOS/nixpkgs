{stdenv, fetchgit, coq, coqPackages}:

let revision = "ee436635a34873c79f49c3d2d507194216f6e8e9"; in

stdenv.mkDerivation rec {

  name = "coq-QuickChick-${coq.coq-version}-${version}";
  version = "20170710-${builtins.substring 0 7 revision}";

  src = fetchgit {
    url = git://github.com/QuickChick/QuickChick.git;
    rev = revision;
    sha256 = "0sq14j1kl4m4plyxj2dbkfwa6iqipmf9w7mxxxcbsm718m0xf1gr";
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
