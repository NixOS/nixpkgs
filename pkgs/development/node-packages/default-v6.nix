{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./composition-v6.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
  pnpm = nodePackages.pnpm.override {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = let
      pnpmLibPath = stdenv.lib.makeBinPath [
        nodejs.passthru.python
        nodejs
      ];
    in ''
      for prog in $out/bin/*; do
        wrapProgram "$prog" --prefix PATH : ${pnpmLibPath}
      done
    '';
  };
}
