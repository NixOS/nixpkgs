{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-jNf61C0yW1a/dGyCbzaJTnzW4yBRnYAyuMsiiTj43XA=";
    linux_arm64 = "sha256-oRzOxPA6a0O5hHgTWvntrBLwJ+du2r1BtKrO/0mO9Vk=";
    darwin_x64 = "sha256-8KJ3/AMo4Q/ZAnO14FJi1cNuRdUGG08o68XlPJgU8Vc=";
    darwin_arm64 = "sha256-H4jHQi9pn5BsI0cYAam5GM+S60EabEwgQAfts/PKWMo=";
  };

  includeInPath = [ ccextractor ];
}
