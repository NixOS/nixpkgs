# Sources required to build CBQN
# Update them all at the same time, or else misbuilds will happen!
# TODO: automate the update of this file

{
  fetchFromGitHub,
}:

{
  cbqn = let
    self = {
      pname = "cbqn";
      version = "0.6.0";

      src = fetchFromGitHub {
        owner = "dzaima";
        repo = "CBQN";
        rev = "v${self.version}";
        hash = "sha256-hd8Z9x5dy7+KjYBMqLC31QblcLS8aqSsVKXIZc6GBeI=";
      };
    };
  in
    self;

  cbqn-bytecode = {
    pname = "cbqn-bytecode";
    version = "0-unstable-2023-12-04";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "cbqnBytecode";
      rev = "fd68e7436976d6106349109a2f8955d8d82d5c6a";
      hash = "sha256-K2bGS3/ALZIL/HQ4bOKJCzeDU+B8UFWwaz8SKN847/0=";
    };
  };

  replxx = {
    pname = "replxx";
    version = "0-unstable-2023-10-31";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "replxx";
      rev = "13f7b60f4f79c2f14f352a76d94860bad0fc7ce9";
      hash = "sha256-xPuQ5YBDSqhZCwssbaN/FcTZlc3ampYl7nfl2bbsgBA=";
    };
  };

  singeli = {
    pname = "singeli";
    version = "0-unstable-2023-12-29";

    src = fetchFromGitHub {
      owner = "mlochbaum";
      repo = "Singeli";
      rev = "5f9cbd46c265491ff167a5d9377d1462539dbdd8";
      hash = "sha256-q8csizarLZhTQ7TaAew4Bz1WB2nM8djxhZfYJNbsro4=";
    };
  };
}
