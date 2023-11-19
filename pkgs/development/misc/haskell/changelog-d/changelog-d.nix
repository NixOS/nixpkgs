{ mkDerivation, base, bytestring, cabal-install-parsers
, Cabal-syntax, containers, directory, fetchgit, filepath
, generic-lens-lite, lib, mtl, optparse-applicative, parsec, pretty
, regex-applicative
}:
mkDerivation {
  pname = "changelog-d";
  version = "0.1";
  src = fetchgit {
    url = "https://codeberg.org/fgaz/changelog-d";
    sha256 = "0r0gr3bl88am9jivic3i8lfi9l5v1dj7xx4fvw6hhy3wdx7z50z7";
    rev = "2816ddb78cec8b7fa4462c25028437ebfe3ad314";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cabal-install-parsers Cabal-syntax containers
    directory filepath generic-lens-lite mtl parsec pretty
    regex-applicative
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
