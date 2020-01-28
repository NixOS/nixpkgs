# PITFALL: If you'd prefer not to run this with `sudo` (which is sensible),
# you'll need to make sure the user has access to the monome.
# When the user does not, running `monomeserial`
# will result in something like:
#   [jeff@jbb-dell:~]$ monomeserial
#   libmonome: could not open monome device: Permission denied
#   failed to open /dev/ttyUSB0
# In that case, run `ls -l <device path>`
# (e.g., for the example above, `ls -l /dev/ttyUSB0`)
# to find the name of the group that owns the device,
# and add it to the user's `extraGroups` in the appropriate `.nix` file.

# MAYBE A PROBLEM, but I'm guessing not:
# The [installation instructions at monome.org](https://monome.org/docs/serialosc/raspbian/)
# indicate that you should use `liblo-dev`, which is a Debian package.
# This package instead depends on `liblo`.
# When I view the Debian package:
#   https://packages.debian.org/jessie/liblo-dev
# it looks like all it contains is liblo 0.28-3:
#   dep: liblo7 (= 0.28-3)
# "liblo" in nixpkgs (currently) installs liblo 0.29:
#   https://nixos.org/nixos/packages.html?channel=nixos-19.03&query=liblo

# I found no wafHook documentation,
# so I aped this file from the nixpkgs repo:
# pkgs/tools/networking/weighttp/default.nix


{ stdenv, libudev, liblo, fetchgit, python3, wafHook}:

stdenv.mkDerivation rec {
  name = "libmonome";
  version = "v1.4.2";

  src = fetchgit {
    url = https://github.com/monome/libmonome.git;
    rev = version;
    # date = 2018-04-30T17:26:39-04:00;
    sha256 = "17g4m17ibpcwyxzh4pqpd7h7xk146ay130jlk3zjjn23fypwahhi";
  };

  nativeBuildInputs = [ wafHook ];
  buildInputs = [
    liblo
    libudev
    python3
  ];
}
