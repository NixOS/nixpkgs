{ mkDerivation, base, containers, fetchgit, lib, mtl, text }:
mkDerivation {
  pname = "elm-format-markdown";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0bcjkcs1dy1csz0mpk7d4b5wf93fsj9p86x8fp42mb0pipdd0bh6";
    rev = "80f15d85ee71e1663c9b53903f2b5b2aa444a3be";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-markdown; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base containers mtl text ];
  doHaddock = false;
  description = "Markdown parsing for Elm documentation comments";
  license = lib.licenses.bsd3;
}
