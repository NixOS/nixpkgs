{ lib
, stdenv
, nukeReferences
, langC
, langCC
, runtimeShell
}:

let
  enableChecksum = (with stdenv; buildPlatform == hostPlatform && hostPlatform == targetPlatform) && langC && langCC && !stdenv.hostPlatform.isDarwin;
in
(pkg: pkg.overrideAttrs (previousAttrs: lib.optionalAttrs enableChecksum {
  outputs = previousAttrs.outputs ++ lib.optionals enableChecksum [ "checksum" ];
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
    #!${runtimeShell}
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
