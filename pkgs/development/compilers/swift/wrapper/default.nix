{
  lib,
  stdenv,
  swift,
  useSwiftDriver ? true,
  swift-driver,
  clang,
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
    cc_wrapper = clang.override (prev: {
      extraBuildCommands =
        prev.extraBuildCommands
        # We need to use the resource directory corresponding to Swift’s
        # version of Clang instead of passing along the one from the
        # `cc-wrapper` flags.
        + ''
          rm -r $out/resource-root
          substituteInPlace $out/nix-support/cc-cflags \
            --replace-fail \
              "-resource-dir=$out/resource-root" \
              "-resource-dir=${lib.getLib swift}/lib/swift/clang"
        ''
        # We need the libc++ headers corresponding to the LLVM version of
        # Swift’s Clang.
        + lib.optionalString (clang.libcxx != null) ''
          include -isystem "${lib.getDev swift}/include/c++/v1" > $out/nix-support/libcxx-cxxflags
        '';
    });

    env.darwinMinVersion = lib.optionalString stdenv.targetPlatform.isDarwin (
      stdenv.targetPlatform.darwinMinVersion
    );

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

      # Propagate any propagated inputs from the unwrapped Swift compiler, if any.
      if [ -e "$swift/nix-support" ]; then
        for input in "$swift/nix-support/"*propagated*; do
          cp "$input" "$out/nix-support/$(basename "$input")"
        done
      fi
    '';

    passthru = {
      inherit swift;
      inherit (swift)
        swiftOs
        swiftArch
        swiftModuleSubdir
        swiftLibSubdir
        tests
        ;
    };
  }
)
