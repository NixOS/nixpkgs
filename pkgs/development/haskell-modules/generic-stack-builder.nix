{
  stdenv,
  ghc,
  pkg-config,
  glibcLocales,
  cacert,
  stack,
  makeSetupHook,
  lib,
}@depArgs:

{
  buildInputs ? [ ],
  nativeBuildInputs ? [ ],
  extraArgs ? [ ],
  LD_LIBRARY_PATH ? [ ],
  ghc ? depArgs.ghc,
  stack ? depArgs.stack,
  ...
}@args:

let

  stackCmd = "stack --internal-re-exec-version=${stack.version}";

  # Add all dependencies in buildInputs including propagated ones to
  # STACK_IN_NIX_EXTRA_ARGS.
  stackHook = makeSetupHook {
    name = "stack-hook";
  } ./stack-hook.sh;

in
stdenv.mkDerivation (
  args
  // {

    # Doesn't work in the sandbox. Pass `--option sandbox relaxed` or
    # `--option sandbox false` to be able to build this
    __noChroot = true;

    buildInputs = buildInputs ++ lib.optional (stdenv.hostPlatform.libc == "glibc") glibcLocales;

    nativeBuildInputs = nativeBuildInputs ++ [
      ghc
      pkg-config
      stack
      stackHook
    ];

    STACK_PLATFORM_VARIANT = "nix";
    STACK_IN_NIX_SHELL = 1;
    STACK_IN_NIX_EXTRA_ARGS = extraArgs;

    # XXX: workaround for https://ghc.haskell.org/trac/ghc/ticket/11042.
    LD_LIBRARY_PATH = lib.makeLibraryPath (LD_LIBRARY_PATH ++ buildInputs);
    # ^^^ Internally uses `getOutput "lib"` (equiv. to getLib)

    # Non-NixOS git needs cert
    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    # Fixes https://github.com/commercialhaskell/stack/issues/2358
    LANG = "en_US.UTF-8";

    preferLocalBuild = true;

    preConfigure = ''
      export STACK_ROOT=$NIX_BUILD_TOP/.stack
    '';

    buildPhase =
      args.buildPhase or ''
        runHook preBuild

        ${stackCmd} build

        runHook postBuild
      '';

    checkPhase =
      args.checkPhase or ''
        runHook preCheck

        ${stackCmd} test

        runHook postCheck
      '';

    doCheck = args.doCheck or true;

    installPhase =
      args.installPhase or ''
        runHook preInstall

        ${stackCmd} --local-bin-path=$out/bin build --copy-bins

        runHook postInstall
      '';
  }
)
