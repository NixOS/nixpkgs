{ lib
, stdenv
, nukeReferences
, version
, langC
, langCC
, langJit
, enablePlugin
, profiledCompiler
, enableExternalBootstrap
, enableLibGccOutput
}:

# libgccjit.so must be built separately
assert langJit -> !enableLibGccOutput;

let
  enableChecksum = enableExternalBootstrap && langC && langCC;
in
{

  mkDerivationOverrides = [

    (pkg: pkg.overrideAttrs (previousAttrs: {
      passthru = previousAttrs.passthru // {
        isFromBootstrapFiles = false;
        inherit enableExternalBootstrap;
      };
      buildFlags = lib.optional
        (with stdenv; targetPlatform == hostPlatform && hostPlatform == buildPlatform)
        (let
          bootstrap = lib.optionalString (!enableExternalBootstrap) "bootstrap";
          profiled  = lib.optionalString profiledCompiler "profiled";
        in "${profiled}${bootstrap}");
      outputs = previousAttrs.outputs
                ++ lib.optionals enableLibGccOutput [ "libgcc" ]
                ++ lib.optionals enableChecksum [ "checksum" ];
    }))

    (pkg: pkg.overrideAttrs (previousAttrs: lib.optionalAttrs ((!langC) || langJit || enableLibGccOutput) {
      # This is a separate phase because gcc assembles its phase scripts
      # in bash instead of nix (we should fix that).
      preFixupPhases = (previousAttrs.preFixupPhases or []) ++ [ "postPostInstallPhase" ];
      postPostInstallPhase = lib.optionalString langJit ''
        # this is to keep clang happy
        mv $out/lib/gcc/${stdenv.targetPlatform.config}/${version}/* $out/lib/gcc/
        rmdir $out/lib/gcc/${stdenv.targetPlatform.config}/${version}
        rmdir $out/lib/gcc/${stdenv.targetPlatform.config}
      '' + lib.optionalString enableLibGccOutput ''
        # eliminate false lib->out references
        find $lib/lib/ -name \*.so\* -exec patchelf --shrink-rpath {} \; || true
      '' + lib.optionalString (!langC) ''
        # delete extra/unused builds of libgcc_s to avoid potential confusion:
        rm -f $out/lib/libgcc_s.so*
      '' + lib.optionalString enableLibGccOutput (''
        # move libgcc from lib to its own output (libgcc)
        mkdir -p $libgcc/lib
        mv    $lib/lib/libgcc_s.so       $libgcc/lib/
        mv    $lib/lib/libgcc_s.so.1     $libgcc/lib/
        ln -s $libgcc/lib/libgcc_s.so   $lib/lib/
        ln -s $libgcc/lib/libgcc_s.so.1 $lib/lib/
      ''
      #
      # Nixpkgs ordinarily turns dynamic linking into pseudo-static linking:
      # libraries are still loaded dynamically, exactly which copy of each
      # library is loaded is permanently fixed at compile time (via RUNPATH).
      # For libgcc_s we must revert to the "impure dynamic linking" style found
      # in imperative software distributions for `libgcc_s`.  This is because
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
      # So we wipe the RUNPATH:
      #
      + ''
        patchelf --set-rpath "" $libgcc/lib/libgcc_s.so.1
      '');
      #
      # Note: `patchelf --remove-rpath` up through (and possibly after) version
      # 0.15.0 will leave the old RUNPATH string in the file where the reference
      # scanner can still find it:
      #
      #   https://github.com/NixOS/patchelf/issues/453
      #
      # ...so we use `--set-rpath ""` instead.  We'll have to keep doing it this
      # way even after that issue is fixed because we might be using the
      # bootstrapFiles' copy of patchelf.
      #
      # That the patchelfing above is *not* effectively equivalent to copying
      # `libgcc_s` into `glibc`'s outpath.  There is one minor and one major
      # difference:
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
    }))

    (pkg: pkg.overrideAttrs (previousAttrs: lib.optionalAttrs enableChecksum {
      # This is a separate phase because gcc assembles its phase scripts
      # in bash instead of nix (we should fix that).
      preFixupPhases = (previousAttrs.preFixupPhases or []) ++ [ "postInstallSaveChecksumPhase" ];
      #
      # gcc uses an auxiliary utility `genchecksum` to md5-hash (most of) its
      # `.o` and `.a` files prior to linking (in case the linker is
      # nondeterministic).  Since we want to compare across gccs built from two
      # separate derivations, we wrap `genchecksum` with a `nuke-references`
      # call.  We also stash copies of the inputs to `genchecksum` in
      # `$checksum/inputs/` -- this is extremely helpful for debugging since
      # it's hard to get Nix to not delete the $NIX_BUILD_TOP of a successful
      # build.
      #
      postInstallSaveChecksumPhase = ''
        mv gcc/build/genchecksum gcc/build/.genchecksum-wrapped
        cat > gcc/build/genchecksum <<\EOF
        #!/bin/sh
        ${nukeReferences}/bin/nuke-refs $@
        for INPUT in "$@"; do install -Dt $INPUT $checksum/inputs/; done
        exec build/.genchecksum-wrapped $@
        EOF
        chmod +x gcc/build/genchecksum
        rm gcc/*-checksum.*
        make -C gcc cc1-checksum.o cc1plus-checksum.o
        install -Dt $checksum/checksums/ gcc/cc*-checksum.o
      '';
    }))
    # the plugins reference $out, so we can't put them in $lib
    (pkg: pkg.overrideAttrs (previousAttrs: lib.optionalAttrs (enableExternalBootstrap && enablePlugin) {
      # This is a separate phase because gcc assembles its phase scripts
      # in bash instead of nix (we should fix that).
      preFixupPhases = (previousAttrs.preFixupPhases or []) ++ [ "postInstallPluginPhase" ];
      postInstallPluginPhase =
        let path = "lib/gcc/${stdenv.targetPlatform.config}/${previousAttrs.version}/"; in ''
          if [ -e "$lib/${path}/plugin" ]; then
            mkdir -p $out/${path}
            mv $lib/${path}/plugin $out/${path}/plugin
          fi
        '';
    }))
  ];
}
