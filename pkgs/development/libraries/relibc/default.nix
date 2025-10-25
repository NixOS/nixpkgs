{
  lib,
  buildPackages,
  callPackage,
  fetchFromGitHub,
  system,
  pkgs,
  rustPlatform,
  makeRustPlatform,
}:

let
  d = i: builtins.trace "${i}" i;
  src = buildPackages.fetchgit {
    url = "https://gitlab.redox-os.org/redox-os/relibc/";
    rev = "6acf185685048eced18597f47d25980dc6c05848";
    hash = "sha256-f9aSeoHFqIVzX+5c4u/RjYEIQ2Jzl0rCcTLPZNLrsi4=";
    fetchSubmodules = true;
  };
  fenixSrc = fetchFromGitHub {
    owner = "nix-community";
    repo = "fenix";
    rev = "fee7cf67cbd80a74460563388ac358b394014238";
    hash = "sha256-3nvEN2lEpWtM1x7nfuiwpYHLNDgEUiWeBbyvy4vtVw8=";
    fetchSubmodules = true;
  };
  fenix = import fenixSrc { };
  rust-nightly-toolchain = d (fenix.fromManifestFile (d "${src}/rust-toolchain.toml"));
  # rustPlatform = buildPackages.makeRustPlatform {
  #   rustc = d rust;
  #   cargo = rust;
  # };
  rust-stable = rustPlatform;
in
callPackage ./relibc.nix {
  inherit src;
  rustPlatform = rust-stable;
  meta = with lib; {
    homepage = "https://gitlab.redox-os.org/redox-os/relibc";
    description = "C Library in Rust for Redox and Linux";
    license = licenses.mit;
    maintainers = [ maintainers.anderscs ];
    platforms = platforms.redox ++ [ "x86_64-linux" ];
  };
}
