{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-VOYM8Ycc6urPd2IqC7/+Q1uzW6DvjaSlVT4QzjKFNUM=";
    linux_arm64 = "sha256-67LQZ2/Wg/xAIejclcPp8BZr9i4IKMMcy6qXIZ2Twxg=";
    darwin_x64 = "sha256-EEOzmsdcz3lVSkOIQyp/paUZTedEZk0C4N4MkhZEnWY=";
    darwin_arm64 = "sha256-G2Rf5xSaC1D6ZgaotpfD3rv7yGxC1hJeb9dhTj7Puhc=";
  };

  includeInPath = [ ccextractor ];
}
