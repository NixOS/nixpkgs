args:

builtins.listToAttrs [
  { name = "3.08.0"; value = import ./3.08.0.nix args; }
  { name = "3.09.1"; value = import ./3.09.1.nix args; }
  { name = "3.10.0"; value = import ./3.10.0.nix args; }
  { name = "default"; value = import ./3.09.1.nix args; }
]
