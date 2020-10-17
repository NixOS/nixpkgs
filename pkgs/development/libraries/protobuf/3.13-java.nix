{ callPackage, protobuf, ... }:

callPackage ./java-v3.nix {
  version = "3.13.0";
  sha256 = "1nqsvi2yfr93kiwlinz8z7c68ilg1j75b2vcpzxzvripxx5h6xhd";
  inherit protobuf;
}
