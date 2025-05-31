# Sources required to build CBQN
# Update them all at the same time, or else misbuilds will happen!
# TODO: automate the update of this file

{
  fetchFromGitHub,
}:

{
  cbqn =
    let
      self = {
        pname = "cbqn";
        version = "0.9.0";

        src = fetchFromGitHub {
          owner = "dzaima";
          repo = "CBQN";
          rev = "v${self.version}";
          hash = "sha256-WGQvnNVnNkz0PR/E5L05KvaaRZ9hgt9gNdzsR9OFYxA=";
        };
      };
    in
    self;

  cbqn-bytecode = {
    pname = "cbqn-bytecode";
    version = "0-unstable-2025-03-16";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "cbqnBytecode";
      rev = "0bdfb86d438a970b983afbca93011ebd92152b88";
      hash = "sha256-oUM4UwLy9tusTFLlaZbbHfFqKEcqd9Mh4tTqiyvMyvo=";
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
    version = "0-unstable-2025-03-13";

    src = fetchFromGitHub {
      owner = "mlochbaum";
      repo = "Singeli";
      rev = "53f42ce4331176d281fa577408ec5a652bdd9127";
      hash = "sha256-NbCNd/m0SdX2/aabeOhAzEYc5CcT/r75NR5ScuYj77c=";
    };
  };
}
