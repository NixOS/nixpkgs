{
  mkDerivation,
  base,
  bytestring,
  cabal-install-parsers,
  Cabal-syntax,
  containers,
  directory,
  fetchFromCodeberg,
  filepath,
  generic-lens-lite,
  lib,
  mtl,
  optparse-applicative,
  parsec,
  pretty,
  regex-applicative,
  frontmatter,
}:
mkDerivation {
  pname = "changelog-d";
  version = "1.0.2-unstable-2026-10-25";
  src = fetchFromCodeberg {
    owner = "fgaz";
    repo = "changelog-d";
    rev = "99905fe1603a518300ac9b61e58ead8ba183c0cd";
    hash = "sha256-XWM3hgjvW7zP3wfgZGxnUjflDwdh+fpKYlJ8j7L7o84=";
  };
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    bytestring
    cabal-install-parsers
    Cabal-syntax
    containers
    directory
    filepath
    generic-lens-lite
    mtl
    parsec
    pretty
    regex-applicative
    frontmatter
  ];
  executableHaskellDepends = [
    base
    bytestring
    Cabal-syntax
    directory
    filepath
    optparse-applicative
  ];
  doHaddock = false;
  description = "Concatenate changelog entries into a single one";
  license = lib.licenses.gpl3Plus;
  mainProgram = "changelog-d";
}
