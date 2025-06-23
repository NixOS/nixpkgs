{
  mkDerivation,
  base,
  containers,
  fetchgit,
  lib,
  mtl,
  text,
}:
mkDerivation {
  pname = "elm-format-markdown";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "13i1wgva6p9zsx1a7sfb3skc0rv187isb920chkhljyh48c12k8l";
    rev = "d07fddc8c0eef412dba07be4ab8768d6abcca796";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-markdown; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base
    containers
    mtl
    text
  ];
  doHaddock = false;
  description = "Markdown parsing for Elm documentation comments";
  license = lib.licenses.bsd3;
}
