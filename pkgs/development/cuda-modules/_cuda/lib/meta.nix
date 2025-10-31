{ _cuda, lib }:
{
  # _mkMetaProblems ∷ [{ assertion ∷ bool, message ∷ str }] → [str]
  _mkMetaProblems = builtins.concatMap (
    {
      assertion,
      kind,
      message,
      urls ? [ ],
      ...
    }@problem:
    lib.lists.optional (!assertion) { inherit kind message urls; }
  );

  # _hasProblemKind ∷ { meta, ... } → bool
  _hasProblemKind =
    kind': finalAttrs: builtins.any ({ kind, ... }: kind == kind') finalAttrs.meta.problems or [ ];

  # _mkMetaBadPlatforms ∷ { meta, ... } → [str]
  #
  # A helper for generating a short list of `badPlatforms` to be displayed in `errormsg` by `check-meta.nix`,
  # when the real requirements of a package are more complex and dynamic than a matching CPU architecture.
  _mkMetaBadPlatforms =
    finalAttrs:
    let
      hasFailedAssertions = _cuda.lib._hasProblemKind "unsupported" finalAttrs;
      finalStdenv = finalAttrs.finalPackage.stdenv;
      badPlatforms = lib.optionals hasFailedAssertions (
        lib.unique [
          finalStdenv.buildPlatform.system
          finalStdenv.hostPlatform.system
          finalStdenv.targetPlatform.system
        ]
      );
    in
    badPlatforms;
}
