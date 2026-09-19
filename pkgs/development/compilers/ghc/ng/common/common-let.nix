# Version metadata shared between `../default.nix` (which needs the attribute
# name of a version before the scope exists) and the component expressions.
#
# Mirrors `gcc/ng/common/common-let.nix`.
{
  lib,
  officialRelease ? null,
  gitRelease ? null,
  version ? null,
}:

assert lib.assertMsg (lib.xor (gitRelease != null) (officialRelease != null)) (
  "must specify `gitRelease` or `officialRelease`"
  + (lib.optionalString (gitRelease != null) " — not both")
);

let
  # Bound outside the `rec` below: inside it, `version` would resolve to the
  # attribute being defined rather than to this argument.
  argVersion = version;
in
rec {
  releaseInfo = rec {
    release_version = if gitRelease != null then gitRelease.version else argVersion;
    # A git release is identified by the date the revision was taken, so that
    # two snapshots of the same in-development version are distinguishable.
    version = release_version + lib.optionalString (gitRelease != null) "-unstable-${gitRelease.date}";
  };

  ghc_meta = {
    homepage = "https://haskell.org/ghc";
    license = lib.licenses.bsd3;
    # Deliberately broad: every component must *evaluate* for the build platform
    # as well as the host, even where it cannot build there. See ../README.md.
    platforms = lib.platforms.all;
  };
}
