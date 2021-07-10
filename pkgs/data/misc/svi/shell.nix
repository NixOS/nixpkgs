{ pkgs ? import ../../../../. {} }: with pkgs;
mkShell {
  nativeBuildInputs = [
    (haskellPackages.ghcWithPackages (ps: []))
    unzip
  ];
}
