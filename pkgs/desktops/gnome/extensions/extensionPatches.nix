{
  lib,
  ddcutil,
  gjs,
}:
# A set of overrides for automatically packaged extensions that require some small fixes.
# The input must be an attribute set with the extensions' UUIDs as keys and the extension
# derivations as values. Output is the same, but with patches applied.
#
# Note that all source patches refer to the built extension as published on extensions.gnome.org, and not
# the upstream repository's sources.
super: super // {

}
