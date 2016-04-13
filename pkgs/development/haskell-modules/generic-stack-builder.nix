{ stdenv, ghc, pkgconfig, glibcLocales }:

with stdenv.lib;

{ buildInputs ? []
, extraArgs ? []
, LD_LIBRARY_PATH ? ""
, ...
}@args:

stdenv.mkDerivation (args // {

  buildInputs =
    buildInputs ++
    optional stdenv.isLinux glibcLocales ++
    [ ghc pkgconfig ];

  STACK_IN_NIX_SHELL=1;
  STACK_IN_NIX_EXTRA_ARGS =
    concatMap (pkg: ["--extra-lib-dirs=${pkg}/lib"
                     "--extra-include-dirs=${pkg}/include"]) buildInputs ++
    extraArgs;

  # XXX: workaround for https://ghc.haskell.org/trac/ghc/ticket/11042.
  LD_LIBRARY_PATH = "${makeLibraryPath buildInputs}:${LD_LIBRARY_PATH}";

  preferLocalBuild = true;

  configurePhase = args.configurePhase or "stack setup";

  buildPhase = args.buildPhase or "stack build";

  checkPhase = args.checkPhase or "stack test";

  doCheck = args.doCheck or true;

  installPhase = args.installPhase or ''
    stack --local-bin-path=$out/bin build --copy-bins
  '';
})
