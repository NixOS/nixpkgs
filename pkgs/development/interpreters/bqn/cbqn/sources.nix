# Sources required to build CBQN
# Update them all at the same time, or else misbuilds will happen!

{
  fetchFromGitHub,
}:

{
  cbqn = let
    self = {
      pname = "cbqn";
      version = "0.5.0";

      src = fetchFromGitHub {
        owner = "dzaima";
        repo = "CBQN";
        rev = "v${self.version}";
        hash = "sha256-PCpePevWQ+aPG6Yx3WqBZ4yTeyJsCGkYMSY6kzGDL1U=";
      };
    };
  in
    self;

  cbqn-bytecode = {
    pname = "cbqn-bytecode";
    version = "0-unstable-2023-05-17";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "cbqnBytecode";
      rev = "32db4dfbfc753835bf112f3d8ae2991d8aebbe3d";
      hash = "sha256-9uBPrEESn/rB9u0xXwKaQ7ABveQWPc8LRMPlnI/79kg=";
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
    version = "0-unstable-2023-11-21";

    src = fetchFromGitHub {
      owner = "mlochbaum";
      repo = "Singeli";
      rev = "528faaf9e2a7f4f3434365bcd91d6c18c87c4f08";
      hash = "sha256-/z1KHqflCqPGC9JU80jtgqdk2mkX06eWSziuf4TU4TM=";
    };
  };
}
