{ mkDerivation, base, containers, fetchgit, lib, mtl, text }:
mkDerivation {
  pname = "elm-format-markdown";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "04l1bn4w8q3ifd6mc4mfrqxfbihmqnpfjdn6gr0x2jqcasjbk0bi";
    rev = "b5cca4c26b473dab06e5d73b98148637e4770d45";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-markdown; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base containers mtl text ];
  doHaddock = false;
  description = "Markdown parsing for Elm documentation comments";
  license = lib.licenses.bsd3;
}
