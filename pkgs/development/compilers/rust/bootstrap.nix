{
  stdenv,
  fetchurl,
  callPackage,
  version,
  hashes,
}:

let
  platform = stdenv.hostPlatform.rust.rustcTarget;

  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
    sha256 = hashes.${platform} or (throw "missing bootstrap url for platform ${platform}");
  };

in
callPackage ./binary.nix {
  inherit version src platform;
  versionType = "bootstrap";
}
