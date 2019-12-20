{ stdenv, runCommand, fetchFromGitHub, ninja, nodejs, python3, ... }:
let
  build-bs-platform = import ./build-bs-platform.nix;
in
(build-bs-platform {
  inherit stdenv runCommand fetchFromGitHub ninja nodejs python3;
  version = "7.0.1";
  ocaml-version = "4.06.1";

  src = fetchFromGitHub {
    owner = "BuckleScript";
    repo = "bucklescript";
    rev = "52770839e293ade2bcf187f2639000ca0a9a1d46";
    sha256 = "0s7g2zfhshsilv9zyp0246bypg34d294z27alpwz03ws9608yr7k";
    fetchSubmodules = true;
  };
}).overrideAttrs (attrs: {
  meta = with stdenv.lib; {
    description = "A JavaScript backend for OCaml focused on smooth integration and clean generated code.";
    homepage = https://bucklescript.github.io;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ turbomack gamb anmonteiro ];
    platforms = platforms.all;
    # Currently there is an issue with aarch build in hydra
    # https://github.com/BuckleScript/bucklescript/issues/4091
    badPlatforms = platforms.aarch64;
  };
})
