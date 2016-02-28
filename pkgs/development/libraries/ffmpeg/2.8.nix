{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.6";
  branch = "2.8";
  sha256 = "0qlfinkyrz4s9z50fmqzx601zf9i7h1yn7cgdwn5jm63kcr1wqa0";
})
