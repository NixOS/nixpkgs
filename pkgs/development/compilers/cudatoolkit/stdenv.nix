{ lib
, nixpkgsCompatibleLibstdcxx
, nvccCompatibleCC
, overrideCC
, stdenv
, wrapCCWith
}:

let
  cc = wrapCCWith
    {
      cc = nvccCompatibleCC;

      # This option is for clang's libcxx, but we (ab)use it for gcc's libstdc++.
      # Note that libstdc++ maintains forward-compatibility: if we load a newer
      # libstdc++ into the process, we can still use libraries built against an
      # older libstdc++. This, in practice, means that we should use libstdc++ from
      # the same stdenv that the rest of nixpkgs uses.
      # We currently do not try to support anything other than gcc and linux.
      libcxx = nixpkgsCompatibleLibstdcxx;
    };
  cudaStdenv = overrideCC stdenv cc;
  passthruExtra = {
    inherit nixpkgsCompatibleLibstdcxx;
    # cc already exposed
  };
  assertCondition = true;
in
lib.extendDerivation
  assertCondition
  passthruExtra
  cudaStdenv

