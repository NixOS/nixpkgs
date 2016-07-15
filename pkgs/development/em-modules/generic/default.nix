{ pkgs, lib, emscripten }:

{ buildInputs ? [], nativeBuildInputs ? []

, enableParallelBuilding ? true

, meta ? {}, ... } @ args:

pkgs.stdenv.mkDerivation (
  args // 
  {

  name = "emscripten-${args.name}";
  buildInputs = [ emscripten ] ++ buildInputs;
  nativeBuildInputs = [ emscripten ] ++ nativeBuildInputs;

  # fake conftest results with emscripten's python magic
  EMCONFIGURE_JS=2;

  configurePhase = args.configurePhase or ''
    # FIXME: Some tests require writing at $HOME
    HOME=$TMPDIR
    runHook preConfigure

    # probably requires autotools as dependency
    ./autogen.sh
    emconfigure ./configure --prefix=$out

    runHook postConfigure
  '';

  buildPhase = args.buildPhase or ''
    runHook preBuild

    HOME=$TMPDIR
    emmake make

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck

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
