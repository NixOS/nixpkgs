# The Nix `gcc' derivation is not directly usable, since it doesn't
# know where the C library and standard header files are.  Therefore
# the compiler produced by that package cannot be installed directly
# in a user environment and used from the command line.  This
# derivation provides a wrapper that sets up the right environment
# variables so that the compiler and the linker just "work".

{stdenv, gcc}:

derivation {
  name = gcc.name; # maybe a bad idea
  system = stdenv.system;
  builder = ./builder.sh;
  glibc = stdenv.param4; # !!! hack
  inherit stdenv gcc;
  inherit (gcc) langC langCC langF77;
}
