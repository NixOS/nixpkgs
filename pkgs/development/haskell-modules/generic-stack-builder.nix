{ stdenv, ghc, pkgconfig, glibcLocales, cacert, stack }@depArgs:

with stdenv.lib;

{ buildInputs ? []
, extraArgs ? []
, LD_LIBRARY_PATH ? []
, ghc ? depArgs.ghc
, stack ? depArgs.stack
, ...
}@args:

let stackCmd = "stack --internal-re-exec-version=${stack.version}";
in stdenv.mkDerivation (args // {

  buildInputs =
    buildInputs ++
    optional stdenv.isLinux glibcLocales ++
    [ ghc pkgconfig stack ];

  STACK_PLATFORM_VARIANT="nix";
  STACK_IN_NIX_SHELL=1;
  STACK_IN_NIX_EXTRA_ARGS =
    concatMap (pkg: ["--extra-lib-dirs=${getLib pkg}/lib"
                     "--extra-include-dirs=${getDev pkg}/include"]) buildInputs ++
    extraArgs;

  # XXX: workaround for https://ghc.haskell.org/trac/ghc/ticket/11042.
  LD_LIBRARY_PATH = makeLibraryPath (LD_LIBRARY_PATH ++ buildInputs);
                    # ^^^ Internally uses `getOutput "lib"` (equiv. to getLib)

  # Non-NixOS git needs cert
  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  # Fixes https://github.com/commercialhaskell/stack/issues/2358
  LANG = "en_US.UTF-8";

  preferLocalBuild = true;

  configurePhase = args.configurePhase or ''
    export STACK_ROOT=$NIX_BUILD_TOP/.stack
  '';

  buildPhase = args.buildPhase or "${stackCmd} build";

  checkPhase = args.checkPhase or "${stackCmd} test";

  doCheck = args.doCheck or true;

  installPhase = args.installPhase or ''
    ${stackCmd} --local-bin-path=$out/bin build --copy-bins
  '';
})
