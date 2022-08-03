{ lib, stdenv, fetchurl, openjdk11, jetbrains }:
let
  version = import ./version.nix;
  dist = {
    x86_64-darwin = {
      arch = "osx-x64";
      sha256 = "e+nI4gK7COE+Wp7mmBJYFPvv3nBWkzf49pBdaGNOdeM=";
    };
    aarch64-darwin = {
      arch = "osx-aarch64";
      sha256 = "4DpSwHNEES74WJhqJOny9ZP8ZYL44ufCKMxCJFrH7Yg=";
    };
  }."${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "jetbrains-jdk";
  version = version.full;
  src = fetchurl {
    # JBR with JCEF (bundled by default with editors)
    url =
      "https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-${version.major}-${dist.arch}-${version.minor}.tar.gz";
    inherit (dist) sha256;
  };
  installPhase = ''
    mkdir -p $out
    mv * $out
  '';
  meta = import ./meta.nix { inherit openjdk11 lib; };
  passthru = { home = "${jetbrains.jdk}/Contents/Home"; };
}
