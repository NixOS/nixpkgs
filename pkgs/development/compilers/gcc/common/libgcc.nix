{ lib
, stdenv
, version
, langC
, langCC
, langJit
, enableShared
, targetPlatform
, hostPlatform
, withoutTargetLibc
, libcCross
}:

assert !stdenv.targetPlatform.hasSharedLibraries -> !enableShared;

drv: lib.pipe drv

([

  (pkg: pkg.overrideAttrs (previousAttrs:
    lib.optionalAttrs (
      targetPlatform != hostPlatform &&
      (enableShared || targetPlatform.isMinGW) &&
      withoutTargetLibc
    ) {
      makeFlags = [ "all-gcc" "all-target-libgcc" ];
      installTargets = "install-gcc install-target-libgcc";
    }))

] ++

# nixpkgs did not add the "libgcc" output until gcc11.  In theory
# the following condition can be changed to `true`, but that has not
# been tested.
lib.optionals (lib.versionAtLeast version "11.0")

(let
  targetPlatformSlash =
    if hostPlatform.config == targetPlatform.config
    then ""
    else "${targetPlatform.config}/";

  # If we are building a cross-compiler and the target libc provided
  # to us at build time has a libgcc, use that instead of building a
  # new one.  This avoids having two separate (but identical) libgcc
  # outpaths in the closure of most packages, which can be confusing.
  useLibgccFromTargetLibc =
    libcCross != null &&
    libcCross?passthru.libgcc;

  enableLibGccOutput =
    (!stdenv.targetPlatform.isWindows || (with stdenv; targetPlatform == hostPlatform)) &&
    !langJit &&
    !stdenv.hostPlatform.isDarwin &&
    enableShared &&
    !useLibgccFromTargetLibc
  ;

  # For some reason libgcc_s.so has major-version "2" on m68k but
  # "1" everywhere else.  Might be worth changing this to "*".
  libgcc_s-version-major =
    if targetPlatform.isM68k
    then "2"
    else "1";

in
[

(pkg: pkg.overrideAttrs (previousAttrs: lib.optionalAttrs useLibgccFromTargetLibc {
  passthru = (previousAttrs.passthru or {}) // {
    inherit (libcCross) libgcc;
  };
}))

(pkg: pkg.overrideAttrs (previousAttrs: lib.optionalAttrs ((!langC) || langJit || enableLibGccOutput) {
  outputs = previousAttrs.outputs ++ lib.optionals enableLibGccOutput [ "libgcc" ];
  # This is a separate phase because gcc assembles its phase scripts
  # in bash instead of nix (we should fix that).
  preFixupPhases = (previousAttrs.preFixupPhases or []) ++ lib.optionals ((!langC) || enableLibGccOutput) [ "preFixupLibGccPhase" ];
  preFixupLibGccPhase =
    # delete extra/unused builds of libgcc_s in non-langC builds
    # (i.e. libgccjit, gnat, etc) to avoid potential confusion
    lib.optionalString (!langC) ''
      rm -f $out/lib/libgcc_s.so*
    ''
    + lib.optionalString (hostPlatform.config != targetPlatform.config) ''
      mkdir -p $lib/lib/
      ln -s ${targetPlatformSlash}lib $lib/lib
    ''

    # TODO(amjoseph): remove the `libgcc_s.so` symlinks below and replace them
    # with a `-L${gccForLibs.libgcc}/lib` in cc-wrapper's
    # `$out/nix-support/cc-flags`.  See also:
    # - https://github.com/NixOS/nixpkgs/pull/209870#discussion_r1130614895
    # - https://github.com/NixOS/nixpkgs/pull/209870#discussion_r1130635982
    # - https://github.com/NixOS/nixpkgs/commit/404155c6acfa59456aebe6156b22fe385e7dec6f
    #
    # move `libgcc_s.so` into its own output, `$libgcc`
    + lib.optionalString enableLibGccOutput (''
      # move libgcc from lib to its own output (libgcc)
      mkdir -p $libgcc/lib
      mv    $lib/${targetPlatformSlash}lib/libgcc_s.so      $libgcc/lib/
      mv    $lib/${targetPlatformSlash}lib/libgcc_s.so.${libgcc_s-version-major}    $libgcc/lib/
      ln -s $libgcc/lib/libgcc_s.so   $lib/${targetPlatformSlash}lib/
      ln -s $libgcc/lib/libgcc_s.so.${libgcc_s-version-major} $lib/${targetPlatformSlash}lib/
    ''
    #
    # Nixpkgs ordinarily turns dynamic linking into pseudo-static linking:
    # libraries are still loaded dynamically, exactly which copy of each
    # library is loaded is permanently fixed at compile time (via RUNPATH).
    # For libgcc_s we must revert to the "impure dynamic linking" style found
    # in imperative software distributions.  We must do this because
    # `libgcc_s` calls `malloc()` and therefore has a `DT_NEEDED` for `libc`,
    # which creates two problems:
    #
    #  1. A circular package dependency `glibc`<-`libgcc`<-`glibc`
    #
    #  2. According to the `-Wl,-rpath` flags added by Nixpkgs' `ld-wrapper`,
    #     the two versions of `glibc` in the cycle above are actually
    #     different packages.  The later one is compiled by this `gcc`, but
    #     the earlier one was compiled by the compiler *that compiled* this
    #     `gcc` (usually the bootstrapFiles).  In any event, the `glibc`
    #     dynamic loader won't honor that specificity without namespaced
    #     manual loads (`dlmopen()`).  Once a `libc` is present in the address
    #     space of a process, that `libc` will be used to satisfy all
    #     `DT_NEEDED`s for `libc`, regardless of `RUNPATH`s.
    #
    # So we wipe the RUNPATH using `patchelf --set-rpath ""`.  We can't use
    # `patchelf --remove-rpath`, because at least as of patchelf 0.15.0 it
    # will leave the old RUNPATH string in the file where the reference
    # scanner can still find it:
    #
    #   https://github.com/NixOS/patchelf/issues/453
    #
    # Note: we might be using the bootstrapFiles' copy of patchelf, so we have
    # to keep doing it this way until both the issue is fixed *and* all the
    # bootstrapFiles are regenerated, on every platform.
    #
    # This patchelfing is *not* effectively equivalent to copying
    # `libgcc_s` into `glibc`'s outpath.  There is one minor and one
    # major difference:
    #
    # 1. (Minor): multiple builds of `glibc` (say, with different
    #    overrides or parameters) will all reference a single store
    #    path:
    #
    #      /nix/store/xxx...xxx-gcc-libgcc/lib/libgcc_s.so.1
    #
    #    This many-to-one referrer relationship will be visible in the store's
    #    dependency graph, and will be available to `nix-store -q` queries.
    #    Copying `libgcc_s` into each of its referrers would lose that
    #    information.
    #
    # 2. (Major): by referencing `libgcc_s.so.1`, rather than copying it, we
    #    are still able to run `nix-store -qd` on it to find out how it got
    #    built!  Most importantly, we can see from that deriver which compiler
    #    was used to build it (or if it is part of the unpacked
    #    bootstrap-files).  Copying `libgcc_s.so.1` from one outpath to
    #    another eliminates the ability to make these queries.
    #
    + ''
      patchelf --set-rpath "" $libgcc/lib/libgcc_s.so.${libgcc_s-version-major}
    '');
}))]))
