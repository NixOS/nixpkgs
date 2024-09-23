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
      version = "0.7.0";

      src = fetchFromGitHub {
        owner = "dzaima";
        repo = "CBQN";
        rev = "v${self.version}";
        hash = "sha256-TUK0HrJ1IyiVi9Y3S1IrK/d4/EZxdRdWyxsAwj79KEc=";
      };
    };
  in
    self;

  cbqn-bytecode = {
    pname = "cbqn-bytecode";
    version = "0-unstable-2024-05-22";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "cbqnBytecode";
      rev = "c5674783c11d7569e5a4d166600ffcde2409331d";
      hash = "sha256-y7gqHzUxVUUVryutlq3Upuso8r3ZRSyF7ydMg1OVlwA=";
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
    version = "0-unstable-2024-02-26";

    src = fetchFromGitHub {
      owner = "mlochbaum";
      repo = "Singeli";
      rev = "ce6ef5d06d35777f0016bbfe0c6c1cf6a9c1b48e";
      hash = "sha256-dDoWoq4LYMD2CKyPxXDAwoeH2E+f0FDyvngtWPEr67w=";
    };
  };
}
