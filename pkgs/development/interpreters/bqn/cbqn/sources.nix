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
        version = "0.11.0";

        src = fetchFromGitHub {
          owner = "dzaima";
          repo = "CBQN";
          rev = "v${self.version}";
          hash = "sha256-ZXhCFLLUVJTgpJqMd97EMSoE4fwuqBJ742kzV662bnY=";
        };
      };
    in
    self;

  cbqn-bytecode = {
    pname = "cbqn-bytecode";
    version = "0-unstable-2026-01-24";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "cbqnBytecode";
      rev = "156b47caf895f6706811c5c34bbbbaf192b8018b";
      hash = "sha256-xz4gs1b1yNbnR3v4Kw1xLCAb1I1uoBMdYJRQH9JVD/k=";
    };
  };

  replxx = {
    pname = "replxx";
    version = "0-unstable-2026-02-02";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "replxx";
      rev = "5e3bd870699007b9536d29f60e3a2b0a68ce0a7a";
      hash = "sha256-B1N1d5K4E20OlbX4wTclEiXULM2FT3oT0btyrYCNQ20=";
    };
  };

  singeli = {
    pname = "singeli";
    version = "0-unstable-2025-11-19";

    src = fetchFromGitHub {
      owner = "mlochbaum";
      repo = "Singeli";
      rev = "2936c66b061b9df61cafc1f8d07a7ed53bf10bee";
      hash = "sha256-vxxGmc0eQxKZN7G0GCGx7xjOWgB1a1jJIcbfbaQd2do=";
    };
  };
}
