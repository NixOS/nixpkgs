{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "34.1";
    hash = "sha256-PaIVJ8NtgnrqowbKLkX+uprsQjuxDch9AUxX4YBBNh4=";
  }
  // args
)
