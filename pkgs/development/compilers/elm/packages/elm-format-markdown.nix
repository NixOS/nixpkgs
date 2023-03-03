{ mkDerivation, base, containers, fetchgit, lib, mtl, text }:
mkDerivation {
  pname = "elm-format-markdown";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "1aiq3mv2ycv6bal5hnz6k33bzmnnidzxxs5b6z9y6lvmr0lbf3j4";
    rev = "7e80dd48dd9b30994e43f4804b2ea7118664e8e0";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-markdown; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base containers mtl text ];
  doHaddock = false;
  description = "Markdown parsing for Elm documentation comments";
  license = lib.licenses.bsd3;
}
