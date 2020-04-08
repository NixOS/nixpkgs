{ stdenv, runCommand, fetchFromGitHub, ninja, nodejs, python3, ... }:
let
  build-bs-platform = import ./build-bs-platform.nix;
in
(build-bs-platform rec {
  inherit stdenv runCommand fetchFromGitHub ninja nodejs python3;
  version = "7.2.0";
  ocaml-version = "4.06.1";

  src = fetchFromGitHub {
    owner = "BuckleScript";
    repo = "bucklescript";
    rev = version;
    sha256 = "1fsx7gvcp6rbqd0qf5fix02mbbmk9rgm09zbwjrx0lp5cjv3n2s4";
    fetchSubmodules = true;
  };
}).overrideAttrs (attrs: {
  meta = with stdenv.lib; {
    description = "A JavaScript backend for OCaml focused on smooth integration and clean generated code.";
    homepage = https://bucklescript.github.io;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ turbomack gamb anmonteiro ];
    platforms = platforms.all;
  };
})
