{ mkDerivation
, fetchFromGitLab
, base
, bytestring
, language-c
, lib
, pretty
, tasty
, unliftio
}:
mkDerivation {
  pname = "libffi-wasm";
  version = "unstable-2022-11-10";
  src = fetchFromGitLab {
    domain = "gitlab.haskell.org";
    owner = "ghc";
    repo = "libffi-wasm";
    rev = "4914da7d7b8b68abf575a47bf88f64b8e1c47ca7";
    sha256 = "0x06bp1mr977g7w4pinp010rfipg3r4l0h92dc9jplbw2lxswhnm";
  };
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [ base bytestring language-c pretty ];
  executableHaskellDepends = [ base bytestring unliftio ];
  testHaskellDepends = [ base tasty ];
  doHaddock = false;
  doCheck = true;
  license = lib.licenses.bsd3;
  maintainers = [ lib.maintainers.sternenseemann ];
  mainProgram = "libffi-wasm";
  homepage = "https://gitlab.haskell.org/ghc/libffi-wasm/";
}
