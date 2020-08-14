{ pkgs, lib, stdenv, callPackage }:

{ buildInputs ? [], nativeBuildInputs ? []
, enableParallelBuilding ? true
, meta ? {}
, platforms ? lib.platforms.all
, ... } @ args:

stdenv.mkDerivation ( args // {
  dontConfigure = args.dontConfigure or true;
  dontBuild = args.dontBuild or true;
  doCheck = args.doCheck or false;
  dontFixup = args.dontFixup or true;

  installPhase = args.configurePhase or ''
    runHook preInstall

    #TODO: Use SOURCE_DATE_EPOCH with install
    find $src -name '*.otf' -exec install -D -t "$out/share/fonts/opentype/" {} \;
    find $src -name '*.ttf' -exec install -D -t "$out/share/fonts/truetype/" {} \;
    find $src -name '*.woff' -exec install -D -t "$out/share/fonts/woff/" {} \;

    runHook postInstall
  '';

  enableParallelBuilding = enableParallelBuilding;

  passthru.tests = {
    render-font-preview-test = callPackage ./test.nix { pname = "${lib.getName args}"; };
  };

  meta = {
    # Add default meta information
    platforms = platforms;
  } // meta;
})
