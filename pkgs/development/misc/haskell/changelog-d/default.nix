{ mkDerivation, base, bytestring, cabal-install-parsers
, Cabal-syntax, containers, directory, fetchFromGitea, filepath
, generic-lens-lite, lib, mtl, optparse-applicative, parsec, pretty
, regex-applicative, frontmatter
}:
mkDerivation rec {
  pname = "changelog-d";
  version = "1.0";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fgaz";
    repo = "changelog-d";
    rev = "v${version}";
    hash = "sha256-cXczIJb5z+Obq13F90oWcgSN1JAVqRWWw4jp2HT5G5Y=";
  };
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cabal-install-parsers Cabal-syntax containers
    directory filepath generic-lens-lite mtl parsec pretty
    regex-applicative frontmatter
  ];
  executableHaskellDepends = [
    base bytestring Cabal-syntax directory filepath
    optparse-applicative
  ];
  doHaddock = false;
  description = "Concatenate changelog entries into a single one";
  license = lib.licenses.gpl3Plus;
  mainProgram = "changelog-d";
}
