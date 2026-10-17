{
  mkDerivation,
  base,
  fetchgit,
  lib,
  prettyprinter,
  prettyprinter-ansi-terminal,
  process,
  QuickCheck,
  text,
  transformers,
}:
mkDerivation {
  pname = "hercules-ci-optparse-applicative";
  version = "0.19.0.0";
  src = fetchgit {
    url = "https://github.com/hercules-ci/optparse-applicative.git";
    sha256 = "sha256-tO0V+TKS+ng6OJ8BztKwmV0tV4TnUXOD01ocTyO0sq0=";
    rev = "0.19.0.0-fork-1";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base
    prettyprinter
    prettyprinter-ansi-terminal
    process
    text
    transformers
  ];
  testHaskellDepends = [
    base
    QuickCheck
  ];
  homepage = "https://github.com/hercules-ci/optparse-applicative";
  description = "Utilities and combinators for parsing command line options (fork)";
  license = lib.licenses.bsd3;
  maintainers = [ lib.maintainers.roberth ];
}
