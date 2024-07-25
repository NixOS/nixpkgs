{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "27.2";
  hash = "sha256-9avetEoB51WblGRy/7FTmhCb06Vi1JfwWv2dxJvna2U=";
} // args)
