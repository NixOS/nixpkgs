{
  lib,
  pkgs,
  python3Packages,
}:
lib.makeOverridable (
  { ... }@nltkDataPkgs:
  f:
  pkgs.symlinkJoin {
    inherit (python3Packages.nltk) meta;
    name = "nltk-data-dir";

    paths = f nltkDataPkgs;
  }
) python3Packages.nltk.data
