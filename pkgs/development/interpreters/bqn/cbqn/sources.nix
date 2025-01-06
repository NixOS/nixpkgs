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
        version = "0.8.0";

        src = fetchFromGitHub {
          owner = "dzaima";
          repo = "CBQN";
          rev = "v${self.version}";
          hash = "sha256-vmd7CX0jgozysmjKK0p5GM4Qd3vY71q1kcKwfr+6fkw=";
        };
      };
    in
    self;

  cbqn-bytecode = {
    pname = "cbqn-bytecode";
    version = "0-unstable-2024-09-15";

    src = fetchFromGitHub {
      owner = "dzaima";
      repo = "cbqnBytecode";
      rev = "c7d83937710889591bad3525077afc30a21e5148";
      hash = "sha256-bEHyiJusddBuTk7MZX1NGvkj66WeOJv5qxBQV6Uhs1E=";
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
    version = "0-unstable-2024-09-29";

    src = fetchFromGitHub {
      owner = "mlochbaum";
      repo = "Singeli";
      rev = "b43f3999b0c5a40b43ceee258fbe6bb8245d06af";
      hash = "sha256-tf5mYIV368Y2cgYJ0U4OZQxuN6kldHUKi9oSjAHbA4Y=";
    };
  };
}
