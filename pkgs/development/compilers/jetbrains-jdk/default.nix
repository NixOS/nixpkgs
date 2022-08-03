{ lib, openjdk11, fetchFromGitHub, jetbrains }:

openjdk11.overrideAttrs (oldAttrs: rec {
  pname = "jetbrains-jdk";
  version = (import ./version.nix).full;
  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "JetBrainsRuntime";
    rev = "jb${version}";
    sha256 = "4tRV6Owl8wY0kJlXDzhyv3fsGIQWREqLXS57Qgs+A2k=";
  };
  patches = [];
  meta = import ./meta.nix { inherit openjdk11 lib; };
  passthru = oldAttrs.passthru // {
    home = "${jetbrains.jdk}/lib/openjdk";
  };
})
