{ mkDerivation, ansi-wl-pprint, base, fetchgit, lib, process, QuickCheck
, transformers, transformers-compat
}:
mkDerivation {
  pname = "hercules-ci-optparse-applicative";
  version = "0.16.1.0";
  src = fetchgit {
    url = "https://github.com/hercules-ci/optparse-applicative.git";
    sha256 = "0v0r11jaav95im82if976256kncp0ji7nfdrlpbgmwxnkj1hxl48";
    rev = "f9d1242f9889d2e09ff852db9dc2d231d9a3e8d8";
    fetchSubmodules = true;
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
