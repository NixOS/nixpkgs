{ stdenv, ghc, pkgconfig, glibcLocales }:

with stdenv.lib;

{ buildInputs ? []
, extraArgs ? []
, LD_LIBRARY_PATH ? []
, ghc ? ghc
, ...
}@args:

stdenv.mkDerivation (args // {

  buildInputs =
    buildInputs ++
    optional stdenv.isLinux glibcLocales ++
    [ ghc pkgconfig ];

  STACK_PLATFORM_VARIANT="nix";
  STACK_IN_NIX_SHELL=1;
  STACK_IN_NIX_EXTRA_ARGS =
    concatMap (pkg: ["--extra-lib-dirs=${getLib pkg}/lib"
                     "--extra-include-dirs=${getDev pkg}/include"]) buildInputs ++
    extraArgs;

  # XXX: workaround for https://ghc.haskell.org/trac/ghc/ticket/11042.
  LD_LIBRARY_PATH = makeLibraryPath (LD_LIBRARY_PATH ++ buildInputs);
                    # ^^^ Internally uses `getOutput "lib"` (equiv. to getLib)

  preferLocalBuild = true;

  configurePhase = args.configurePhase or ''
    export STACK_ROOT=$NIX_BUILD_TOP/.stack
    stack setup
  '';

  buildPhase = args.buildPhase or "stack build";

  checkPhase = args.checkPhase or "stack test";

  doCheck = args.doCheck or true;

  installPhase = args.installPhase or ''
    stack --local-bin-path=$out/bin build --copy-bins
  '';
})
