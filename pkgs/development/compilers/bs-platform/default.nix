{ stdenv, runCommand, fetchFromGitHub, ninja, nodejs, python3, ... }:
let
  build-bs-platform = import ./build-bs-platform.nix;
in
(build-bs-platform rec {
  inherit stdenv runCommand fetchFromGitHub ninja nodejs python3;
  version = "7.3.2";
  ocaml-version = "4.06.1";

  src = fetchFromGitHub {
    owner = "BuckleScript";
    repo = "bucklescript";
    rev = version;
    sha256 = "1nvp7wiiv149r4qf9bgc84bm4w7s44sjq9i7j103v24wllzz218s";
    fetchSubmodules = true;
  };
}).overrideAttrs (attrs: {
  meta = with stdenv.lib; {
    description = "A JavaScript backend for OCaml focused on smooth integration and clean generated code.";
    homepage = "https://bucklescript.github.io";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ turbomack gamb anmonteiro ];
    platforms = platforms.all;
  };
})
