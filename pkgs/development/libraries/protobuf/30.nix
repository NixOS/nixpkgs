{ callPackage, ... }@args:

callPackage ./generic.nix (
  {
    version = "30.1";
    hash = "sha256-t+PpWqrea8oTElIDbIPdIMFvQYlmqig2wCQ7V8nUqOI=";
  }
  // args
)
