{
  mkDerivation,
  aeson,
  async,
  base,
  brick,
  bytestring,
  clock,
  containers,
  directory,
  dot,
  filepath,
  hedgehog,
  hrfsize,
  lib,
  microlens,
  optparse-applicative,
  relude,
  terminal-progress-bar,
  text,
  typed-process,
  unordered-containers,
  vty,
}:
mkDerivation {
  pname = "nix-tree";
  version = "0.6.3";
  sha256 = "06dzf87vckd11yiq2ng6l80rd17p920lajykn1vy2azyhivkp59j";
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson
    async
    base
    brick
    bytestring
    clock
    containers
    directory
    dot
    filepath
    hrfsize
    microlens
    optparse-applicative
    relude
    terminal-progress-bar
    text
    typed-process
    unordered-containers
    vty
  ];
  testHaskellDepends = [
    aeson
    base
    brick
    bytestring
    clock
    containers
    directory
    dot
    filepath
    hedgehog
    hrfsize
    microlens
    optparse-applicative
    relude
    text
    typed-process
    unordered-containers
    vty
  ];
  description = "Interactively browse a Nix store paths dependencies";
  license = lib.licenses.bsd3;
  mainProgram = "nix-tree";
  maintainers = [ lib.maintainers.utdemir ];
}
