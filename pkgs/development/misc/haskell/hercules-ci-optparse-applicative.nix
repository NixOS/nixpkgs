{ mkDerivation, ansi-wl-pprint, base, fetchgit, lib, process, QuickCheck
, transformers, transformers-compat
}:
mkDerivation {
  pname = "hercules-ci-optparse-applicative";
  version = "0.16.1.0";
  src = fetchgit {
    url = "https://github.com/hercules-ci/optparse-applicative.git";
    sha256 = "05vchaw2rf46hh2128qjpky686iy5hff964mbdhcyiz612jjflyp";
    rev = "9e2968c09a7c5b29d04578dc68d81ce5aec0591e";
  };
  libraryHaskellDepends = [
    ansi-wl-pprint base process transformers transformers-compat
  ];
  testHaskellDepends = [ base QuickCheck ];
  homepage = "https://github.com/hercules-ci/optparse-applicative";
  description = "Utilities and combinators for parsing command line options (fork)";
  license = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [ roberth ];
}
