{
  mkDerivation,
  base,
  fetchFromGitHub,
  lib,
  prettyprinter,
  prettyprinter-ansi-terminal,
  process,
  QuickCheck,
  text,
  transformers,
  transformers-compat,
}:
mkDerivation {
  pname = "hercules-ci-optparse-applicative";
  version = "0.18.1.0";
  src = fetchFromGitHub {
    owner = "hercules-ci";
    repo = "optparse-applicative";
    sha256 = "1cgxc80zfgzk4rrhspnlj7790jb0ddq7ybj7qjan5xmjjir90763";
    rev = "a123939663ba1cd0f1750343f1c6b9864ac21207";
  };
  libraryHaskellDepends = [
    base
    prettyprinter
    prettyprinter-ansi-terminal
    process
    text
    transformers
    transformers-compat
  ];
  testHaskellDepends = [
    base
    QuickCheck
  ];
  homepage = "https://github.com/hercules-ci/optparse-applicative";
  description = "Utilities and combinators for parsing command line options (fork)";
  license = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [ roberth ];
}
