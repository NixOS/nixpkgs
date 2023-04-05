{ mkDerivation, ansi-wl-pprint, base, fetchFromGitHub, lib, process, QuickCheck
, transformers, transformers-compat
}:
mkDerivation {
  pname = "hercules-ci-optparse-applicative";
  version = "0.16.1.0";
  src = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "optparse-applicative";
    rev = "3d20deefbef2e66d3c075facc5d01c1aede34f3c";
    sha256 = "sha256-FnFbPvy5iITT7rAjZBBUNQdo3UDP2z8iLg0MiIdXMdo=";
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
