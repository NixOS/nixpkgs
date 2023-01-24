{ callPackage, ... }@args:

callPackage ./generic.nix (rec {
  version = "4.4.3";
  branch = version;
  sha256 = "sha256-M7jC281TD+HbVxBBU0Vgm0yiJ70NoeOpMy27DxH9Jzo=";

} // args)
