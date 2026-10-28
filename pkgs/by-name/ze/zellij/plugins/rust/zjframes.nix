{ callPackage }:
# zjstatus and zjframes are contained in the same repository, but as different crates
let
  zjstatus = callPackage ./zjstatus.nix { _binaryName = "zjframes"; };
in
zjstatus.overrideAttrs (old: {
  pname = "zjframes";

  meta = old.meta // {
    description = "Toggle Zellij pane frames based on different conditions";
  };
})
