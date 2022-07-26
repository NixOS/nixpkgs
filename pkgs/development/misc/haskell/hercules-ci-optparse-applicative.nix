{ mkDerivation, ansi-wl-pprint, base, fetchFromGitHub, lib, process, QuickCheck
, transformers, transformers-compat
}:
mkDerivation {
  pname = "hercules-ci-optparse-applicative";
  version = "0.16.1.0";
  src = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "optparse-applicative";
    rev = "9e2968c09a7c5b29d04578dc68d81ce5aec0591e";
    sha256 = "sha256-11MnpQjmR89gW5WY5BwsPhpk/LwSIxEEhIa4LLiCbBc=";
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
