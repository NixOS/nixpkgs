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
        version = "0.10.0";

        src = fetchFromGitHub {
          owner = "dzaima";
          repo = "CBQN";
          rev = "v${self.version}";
          hash = "sha256-RZIxIRlx1SSYP+WrMRvg6nUqqs4zqEaGPvFyY3WFgbU=";
        };
      };
    in
    self;

  cbqn-bytecode = {
    pname = "cbqn-bytecode";
    version = "0-unstable-2025-11-24";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "cbqnBytecode";
      rev = "cca48b93b2e3260d2fa371c578d94cf044e39042";
      hash = "sha256-xBjXlzWhbsKjiknnncVRkh9VlUNzaxYVNB7BhZTI/r4=";
    };
  };

  replxx = {
    pname = "replxx";
    version = "0-unstable-2025-05-20";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "replxx";
      rev = "c1ce5b0bcabd96ec93ebf630a85619295ec7c2f3";
      hash = "sha256-4TEjJdF0FAIT69uVMp0y4bFFrRda1CXC/bLX6mrUTA0=";
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
