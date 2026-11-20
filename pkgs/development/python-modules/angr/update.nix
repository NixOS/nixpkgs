{
  coreutils,
  git,
  gnused,
  jq,
  nix,
  nix-update,
  writeShellApplication,
}:

writeShellApplication {
  name = "angr-update";
  runtimeInputs = [
    coreutils
    git
    gnused
    jq
    nix
    nix-update
  ];
  text = builtins.readFile ./update.sh;
}
