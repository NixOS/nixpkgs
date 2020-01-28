# PITFALL: Depends on libmonome, which is available from this repo, or from
# [my fork of nixpkgs](https://github.com/JeffreyBenjaminBrown/nixpkgs),
# but which is not yet part of the nixpkgs master branch.

{ stdenv, libmonome, liblo, fetchgit, python3, wafHook, libudev, udev, systemd, avahi-compat, avahi }:

stdenv.mkDerivation rec {
  name = "serialosc";
  version = "v1.4.1";

  src = fetchgit {
    # Once, it seemed to finish, and I don't know how! Then it crashed with:
    # Switched to a new branch 'fetchgit'
    # removing `.git'...
    # hash mismatch in fixed-output derivation '/nix/store/5zj802wfjd0ima92lpzzsqdjqvrnrwf9-serialosc':
    # wanted: sha256:1vqcxi32wc4pklbddllflkaigkfvd4ykwrjqccayvrk10dx1sna3
    # got:    sha256:1zmzjasv21ix7i7s58a31k0025ji32hv2jm2ww6s0xhjmr5ax34j

    # This way it [[gets pretty far]].
    # The fetchSubmodules value I set again seems to have no effect.
    url = https://github.com/monome/serialosc.git;
    rev = "v1.4.1";
    sha256 = "1zmzjasv21ix7i7s58a31k0025ji32hv2jm2ww6s0xhjmr5ax34j";

    # For this I duplicated the serialosc repo including all submodules.
    # It seems to behave just like the [[gets pretty far]] config.
    # url = https://github.com/JeffreyBenjaminBrown/serialosc-nix-cheat;
    # sha256 = "1pm49yqimpard9x2qbma1gyxlmv5bk0kwppn5djnfklgp636km1n";

    # This is currently the hash of master.
    # Gives me "Submodules aren't initialized!"
    # url = https://github.com/monome/serialosc.git;
    # sha256 = "0hc8jpn4vbv52g9rnqprfjybbhvj6dzra5rkdyq9g6h4fqpqlrwm";

    # If I use what prefetch gives me, it always fails, with
    # "Submodules aren't initialized!"
    # url = https://github.com/monome/serialosc.git;
    # sha256 = "1vqcxi32wc4pklbddllflkaigkfvd4ykwrjqccayvrk10dx1sna3";
    # I've tried fetchSubmodules = false, true, or omitted.
  };

  nativeBuildInputs = [ wafHook ];
  buildInputs = [
    avahi
    avahi-compat
    liblo
    libmonome
    libudev
    libudev
    python3
    systemd
    udev
  ];
}
