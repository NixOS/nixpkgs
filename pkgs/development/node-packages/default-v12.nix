{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./composition-v12.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
  makam =  nodePackages.makam.override {
    buildInputs = [ pkgs.nodejs pkgs.makeWrapper ];
    postFixup = ''
      wrapProgram "$out/bin/makam" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.nodejs ]}
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 "$out/lib/node_modules/makam/makam-bin-linux64"
    '';
  };

  node2nix = nodePackages.node2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/node2nix" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.nix ]}
    '';
  };
}
