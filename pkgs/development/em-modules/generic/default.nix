{ pkgs, lib, emscripten, python }:

{ buildInputs ? [], nativeBuildInputs ? []

, enableParallelBuilding ? true

, meta ? {}, ... } @ args:

pkgs.stdenv.mkDerivation (
  args //
  {

  pname = "emscripten-${lib.getName args}";
  version = lib.getVersion args;
  buildInputs = [ emscripten python ] ++ buildInputs;
  nativeBuildInputs = [ emscripten python ] ++ nativeBuildInputs;

  # fake conftest results with emscripten's python magic
  EMCONFIGURE_JS=2;

  configurePhase = args.configurePhase or ''
    # FIXME: Some tests require writing at $HOME
    HOME=$TMPDIR
    runHook preConfigure

    emconfigure ./configure --prefix=$out

    runHook postConfigure
  '';

  buildPhase = args.buildPhase or ''
    runHook preBuild

    HOME=$TMPDIR
    emmake make

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = args.checkPhase or ''
    runHook preCheck

    echo "Please provide a test for your emscripten based library/tool, see libxml2 as an exmple on how to use emcc/node to verify your build"
    echo ""
    echo "In normal C 'unresolved symbols' would yield an error and a breake of execution. In contrast, in emscripten they are only a warning which is ok given that emscripten assumptions about shared libraries."
    echo "  -> https://github.com/kripken/emscripten/wiki/Linking"
    echo "So just assume the dependencies were built using hydra, then YOU WILL NEVER see the warning and your code depending on a library will always fail!"
    exit 1

    runHook postCheck
  '';

  enableParallelBuilding = args.enableParallelBuilding or true;

  meta = {
    # Add default meta information
    platforms = lib.platforms.all;
    # Do not build this automatically
    hydraPlatforms = [];
  } // meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++
                  [ lib.maintainers.qknight ];
  };
})
