{ stdenv, fetchurl }:

let
  fetch = { version, src ? builtins.getAttr stdenv.system sources, sources ? null }:
  {
    inherit version src;
  };

in {
  v10_0_2 = fetch {
    version = "10.0.2";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.10.00.p02.tar.gz";
      sha256 = "9d615200901f1a5760970e8f5970625ea146253e4f7c5ad9df2a9cf84549e848";
    };  
  };
}

