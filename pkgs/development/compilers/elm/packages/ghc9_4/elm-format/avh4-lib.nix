{
  mkDerivation,
  array,
  base,
  bytestring,
  directory,
  fetchgit,
  filepath,
  lib,
  mtl,
  pooled-io,
  process,
  relude,
  tasty,
  tasty-discover,
  tasty-hspec,
  tasty-hunit,
  text,
}:
mkDerivation {
  pname = "avh4-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "04l1bn4w8q3ifd6mc4mfrqxfbihmqnpfjdn6gr0x2jqcasjbk0bi";
    rev = "b5cca4c26b473dab06e5d73b98148637e4770d45";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/avh4-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    array
    base
    bytestring
    directory
    filepath
    mtl
    pooled-io
    process
    relude
    text
  ];
  testHaskellDepends = [
    array
    base
    bytestring
    directory
    filepath
    mtl
    pooled-io
    process
    relude
    tasty
    tasty-hspec
    tasty-hunit
    text
  ];
  testToolDepends = [ tasty-discover ];
  description = "Common code for haskell projects";
  license = lib.licenses.bsd3;
}
