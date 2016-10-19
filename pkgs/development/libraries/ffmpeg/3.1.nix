{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.4";
  branch = "3.1";
  sha256 = "1ynb1f0py5jb6hs78ypynpwc3jlqrw51vl8y1wnd44nwlisxz6bw";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
