{
  lib,
  makeSetupHook,
  runCommand,
  runtimeShell,
  swift,
  xtool,
}:

let
  # TODO: drop once Swift's bin/clang can build for Apple targets.
  # The cc-wrapper adds Linux link flags to every link, and swift-build scans
  # with the fork's libclang, whose flags upstream clang rejects.
  swift' = swift.override (prev: {
    llvmPackages_upstream = prev.llvmPackages_upstream // {
      clang = runCommand "xtool-clang" { } ''
        mkdir -p $out/bin
        # Swift reads the libc flags from here
        ln -s ${prev.llvmPackages_upstream.clang}/nix-support $out/nix-support
        for c in clang clang++; do
          substitute ${./clang.sh} $out/bin/$c \
            --subst-var-by shell ${runtimeShell} \
            --subst-var-by apple ${prev.llvmPackages.clang-unwrapped}/bin/$c \
            --subst-var-by host ${prev.llvmPackages_upstream.clang}/bin/$c
          chmod +x $out/bin/$c
        done
      '';
    };
  });
in
makeSetupHook {
  name = "xtool-build-hook";
  propagatedBuildInputs = [
    xtool
    swift'
  ];
  substitutions.sdk = xtool.sdk;
  passthru.tests = xtool.tests;
  meta = {
    description = "Setup hook for building iOS apps with xtool";
    inherit (xtool.meta) maintainers;
    inherit (xtool.sdk.meta) platforms;
    hydraPlatforms = [ ];
    license = lib.licenses.mit;
  };
} ./hook.sh
