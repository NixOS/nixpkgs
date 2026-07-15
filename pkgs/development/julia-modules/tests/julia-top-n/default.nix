{
  mkDerivation,
  aeson,
  base,
  filepath,
  lib,
  optparse-applicative,
  sandwich,
  text,
  unliftio,
  yaml,
}:
mkDerivation {
  pname = "julia-top-n";
  version = "0.1.0.0";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./app
      ./julia-top-n.cabal
      ./package.yaml
      ./stack.yaml
      ./stack.yaml.lock
    ];
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson
    base
    filepath
    optparse-applicative
    sandwich
    text
    unliftio
    yaml
  ];
  license = lib.licenses.bsd3;
  mainProgram = "julia-top-n-exe";
}
