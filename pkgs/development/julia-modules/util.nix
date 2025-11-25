{
  gitMinimal,
  lib,
  runCommand,
}:

{
  # Add packages to a Python environment. Works if you pass something like either
  # a) python3
  # b) python3.withPackages (ps: [...])
  # See https://github.com/NixOS/nixpkgs/pull/97467#issuecomment-689315186
  addPackagesToPython =
    python: packages:
    # TODO: this stopped working because "env" ended up being a key of the base
    # derivation like "python3" as well. Is there a robust way to determine if
    # this Python is already wrapped?
    if python ? "env" && lib.isDerivation python.env then
      python.override (old: {
        extraLibs = old.extraLibs ++ packages;
      })
    else
      python.withPackages (ps: packages);

  # Convert an ordinary source checkout into a repo with a single commit
  repoifySimple =
    name: path:
    runCommand ''${name}-repoified'' { buildInputs = [ gitMinimal ]; } ''
      mkdir -p $out
      cp -r ${path}/. $out
      cd $out
      chmod -R u+w .
      rm -rf .git
      git init
      git add . -f
      git config user.email "julia2nix@localhost"
      git config user.name "julia2nix"
      git commit -m "Dummy commit"
    '';

  # Convert an dependency source info into a repo with a single commit
  repoifyInfo =
    uuid: info:
    runCommand ''julia-${info.name}-${info.version}'' { buildInputs = [ gitMinimal ]; } ''
      mkdir -p $out
      cp -r ${info.src}/. $out
      cd $out
      chmod -R u+w .
      rm -rf .git
      git init
      git add . -f
      git config user.email "julia2nix@localhost"
      git config user.name "julia2nix"
      git commit -m "Dummy commit"
    '';
}
