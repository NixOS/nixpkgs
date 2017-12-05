{ callPackage }:
{
  ticcutils = callPackage ./ticcutils.nix { };
  libfolia = callPackage ./libfolia.nix { };
  ucto = callPackage ./ucto.nix { };
  uctodata = callPackage ./uctodata.nix { };
  timbl = callPackage ./timbl.nix { };
  timblserver = callPackage ./timblserver.nix { };
  mbt = callPackage ./mbt.nix { };
  frog = callPackage ./frog.nix { };
  frogdata = callPackage ./frogdata.nix { };

  test = callPackage ./test.nix { };
}
