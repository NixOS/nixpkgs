# Assemble GHC's `lib/settings` from its two honest halves.
#
#   o `ghc-toolchain` probes the C toolchain and writes what follows from it
#     (`./settings.nix` -> `settings.json`).
#   o Everything else is a fact about *this build*, not about the target, and
#     is passed in here from Nix.
#
# The merge happens inside a derivation with `jq`, so the probe's output -- a
# build artefact -- never has to be read at evaluation time. No IFD.
#
# The build-state half is not a rounding error. From a real GHC 9.14.1:
#
#     ("base unit-id","base-4.22.0.0-95fb")
#     ("RTS ways","v thr thr_debug thr_debug_p ... dyn")
#     ("Relative Global Package DB","package.conf.d")
#
# `base unit-id` carries a hash of the `base` that was built. Guessing it, as
# stable-haskell's `--output-settings` does by writing `""`, yields a compiler
# that cannot find `base`.
{
  lib,
  runCommand,
  jq,

  # `ghc-settings-*` from ./settings.nix, providing `settings.json`.
  toolchainSettings,

  # -- The build-state half. ------------------------------------------------

  # Unit-id of the `base` this compiler ships, e.g. `base-4.22.0.0-95fb`.
  baseUnitId,

  # RTS ways actually built, e.g. [ "v" "thr" "thr_debug" "dyn" ].
  rtsWays,

  # Where the global package db sits relative to the settings file.
  relativeGlobalPackageDb ? "package.conf.d",

  # `$topdir` is expanded by GHC when it reads the file.
  unlitCommand ? "$topdir/../bin/unlit",

  crossCompiling,
  targetHasLibm,
  useInplaceMinGW ? false,
  useInterpreter,
  supportSMP,
  rtsExpectsLibdw ? false,
  rtsLinkerOnlySupportsSharedLibs ? false,
}:

let
  yesNo = b: if b then "YES" else "NO";

  buildStateSettings = {
    "base unit-id" = baseUnitId;
    "RTS ways" = lib.concatStringsSep " " rtsWays;
    "Relative Global Package DB" = relativeGlobalPackageDb;
    "unlit command" = unlitCommand;
    "cross compiling" = yesNo crossCompiling;
    "target has libm" = yesNo targetHasLibm;
    "Use inplace MinGW toolchain" = yesNo useInplaceMinGW;
    "Use interpreter" = yesNo useInterpreter;
    "Support SMP" = yesNo supportSMP;
    "RTS expects libdw" = yesNo rtsExpectsLibdw;
    "target RTS linker only supports shared libraries" = yesNo rtsLinkerOnlySupportsSharedLibs;
  };
in

runCommand "ghc-settings"
  {
    nativeBuildInputs = [ jq ];
    # `builtins.toJSON` of a Nix attrset is exactly the format we need, so the
    # build-state half needs no serialiser of its own.
    buildStateJson = builtins.toJSON buildStateSettings;
    passthru = { inherit buildStateSettings toolchainSettings; };
  }
  ''
    mkdir -p "$out"
    printf '%s' "$buildStateJson" > build-state.json

    # The two halves must be disjoint: each key has exactly one source that can
    # honestly answer for it. Assert that rather than letting a silent
    # right-biased union paper over a key migrating from one half to the other.
    overlap=$(jq -r -s '[.[0] | keys[]] - ([.[0] | keys[]] - [.[1] | keys[]]) | .[]' \
      "${toolchainSettings}/settings.json" build-state.json)
    if [ -n "$overlap" ]; then
      echo "ghc/ng: toolchain and build-state settings both define:" >&2
      echo "$overlap" >&2
      echo "One of the two halves is claiming a key that is not its to answer." >&2
      exit 1
    fi

    jq -s '.[0] * .[1]' "${toolchainSettings}/settings.json" build-state.json \
      > "$out/settings"

    # Left as JSON deliberately: it is what we generated, GHC accepts either
    # format (see patches/settings-json.patch), and it stays diffable.
    echo "--- assembled settings ---"
    cat "$out/settings"
  ''
