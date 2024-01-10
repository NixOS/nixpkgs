{
  lib,
  nvccCompatibilities,
  cudaVersion,
  buildPackages,
  overrideCC,
  stdenv,
  wrapCCWith,
}:

let
  gccMajorVersion = nvccCompatibilities.${cudaVersion}.gccMaxMajorVersion;
  # We use buildPackages (= pkgsBuildHost) because we look for a gcc that
  # runs on our build platform, and that produces executables for the host
  # platform (= platform on which we deploy and run the downstream packages).
  # The target platform of buildPackages.gcc is our host platform, so its
  # .lib output should be the libstdc++ we want to be writing in the runpaths
  # Cf. https://github.com/NixOS/nixpkgs/pull/225661#discussion_r1164564576
  ccForLibs = stdenv.cc.cc;
  cxxStdlib = lib.getLib ccForLibs;
  nvccCompatibleCC = buildPackages."gcc${gccMajorVersion}".cc;

  cc = wrapCCWith {
    cc = nvccCompatibleCC;

    # Note: normally the `useCcForLibs`/`gccForLibs` mechanism is used to get a
    # clang based `cc` to use `libstdc++` (from gcc).

    # Here we (ab)use it to use a `libstdc++` from a different `gcc` than our
    # `cc`.

    # Note that this does not inhibit our `cc`'s lib dir from being added to
    # cflags/ldflags (see `cc_solib` in `cc-wrapper`) but this is okay: our
    # `gccForLibs`'s paths should take precedence.
    useCcForLibs = true;
    gccForLibs = ccForLibs;
  };
  cudaStdenv = overrideCC stdenv cc;
  passthruExtra = {
    nixpkgsCompatibleLibstdcxx = lib.warn "cudaPackages.backendStdenv.nixpkgsCompatibleLibstdcxx is misnamed, deprecated, and will be removed after 24.05" cxxStdlib;
    # cc already exposed
  };
  assertCondition = true;
in

# We should use libstdc++ at least as new as nixpkgs' stdenv's one.
assert ((stdenv.cc.cxxStdlib.kind or null) == "libstdc++")
  -> lib.versionAtLeast cxxStdlib.version stdenv.cc.cxxStdlib.package.version;

lib.extendDerivation assertCondition passthruExtra cudaStdenv
