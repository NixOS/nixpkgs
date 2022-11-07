{ pkgs ? import <nixpkgs> { } }:
let nix-cl = (import ./. { claspPkg = pkgs.clasp; }) { inherit pkgs; };
in pkgs.mkShell {
  nativeBuildInputs = [
    (nix-cl.sbclWithPackages
      (ps: with ps; [ alexandria str dexador cl-ppcre sqlite arrow-macros jzon ]))
  ];
}
