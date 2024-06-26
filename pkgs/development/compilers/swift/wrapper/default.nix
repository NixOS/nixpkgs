{
  lib,
  stdenv,
  swift,
  useSwiftDriver ? true,
  swift-driver,
}:

stdenv.mkDerivation (
  swift._wrapperParams
  // {
    pname = "swift-wrapper";
    inherit (swift) version meta;

    outputs = [
      "out"
      "man"
    ];

    # Wrapper and setup hook variables.
    inherit swift;
    inherit (swift)
      swiftOs
      swiftArch
      swiftModuleSubdir
      swiftLibSubdir
      swiftStaticModuleSubdir
      swiftStaticLibSubdir
      ;
    swiftDriver = lib.optionalString useSwiftDriver "${swift-driver}/bin/swift-driver";

    passAsFile = [ "buildCommand" ];
    buildCommand = ''
      mkdir -p $out/bin $out/nix-support

      # Symlink all Swift binaries first.
      # NOTE: This specifically omits clang binaries. We want to hide these for
      # private use by Swift only.
      ln -s -t $out/bin/ $swift/bin/swift*

      # Replace specific binaries with wrappers.
      for executable in swift swiftc swift-frontend; do
        export prog=$swift/bin/$executable
        rm $out/bin/$executable
        substituteAll '${./wrapper.sh}' $out/bin/$executable
        chmod a+x $out/bin/$executable
      done

      ${lib.optionalString useSwiftDriver ''
        # Symlink swift-driver executables.
        ln -s -t $out/bin/ ${swift-driver}/bin/*
      ''}

      ln -s ${swift.man} $man

      # This link is here because various tools (swiftpm) check for stdlib
      # relative to the swift compiler. It's fine if this is for build-time
      # stuff, but we should patch all cases were it would end up in an output.
      ln -s ${swift.lib}/lib $out/lib

      substituteAll ${./setup-hook.sh} $out/nix-support/setup-hook
    '';

    passthru = {
      inherit swift;
      inherit (swift)
        swiftOs
        swiftArch
        swiftModuleSubdir
        swiftLibSubdir
        ;
    };
  }
)
