{ lib, stdenv, nim, nim_builder }:
<<<<<<< HEAD
pkgArgs:

let
  baseAttrs = {
    strictDeps = true;
    enableParallelBuilding = true;
    doCheck = true;
    configurePhase = ''
      runHook preConfigure
      export NIX_NIM_BUILD_INPUTS=''${pkgsHostTarget[@]} $NIX_NIM_BUILD_INPUTS
      nim_builder --phase:configure
      runHook postConfigure
    '';
    buildPhase = ''
      runHook preBuild
      nim_builder --phase:build
      runHook postBuild
    '';
    checkPhase = ''
      runHook preCheck
      nim_builder --phase:check
      runHook postCheck
    '';
    installPhase = ''
      runHook preInstall
      nim_builder --phase:install
      runHook postInstall
    '';
    meta = { inherit (nim.meta) maintainers platforms; };
  };

  inputsOverride =
    { depsBuildBuild ? [ ], nativeBuildInputs ? [ ], ... }: {
      depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
      nativeBuildInputs = [ nim ] ++ nativeBuildInputs;
    };

  composition = finalAttrs:
    let
      asFunc = x: if builtins.isFunction x then x else (_: x);
      prev = baseAttrs // (asFunc ((asFunc pkgArgs) finalAttrs)) baseAttrs;
    in prev // inputsOverride prev;

in stdenv.mkDerivation composition
=======

{ strictDeps ? true, depsBuildBuild ? [ ], nativeBuildInputs ? [ ]
, configurePhase ? null, buildPhase ? null, checkPhase ? null
, installPhase ? null, enableParallelBuilding ? true, meta ? { }, ... }@attrs:

stdenv.mkDerivation (attrs // {
  inherit strictDeps enableParallelBuilding;
  depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
  nativeBuildInputs = [ nim ] ++ nativeBuildInputs;

  configurePhase = if (configurePhase == null) then ''
    runHook preConfigure
    export NIX_NIM_BUILD_INPUTS=''${pkgsHostTarget[@]} $NIX_NIM_BUILD_INPUTS
    nim_builder --phase:configure
    runHook postConfigure
  '' else
    configurePhase;

  buildPhase = if (buildPhase == null) then ''
    runHook preBuild
    nim_builder --phase:build
    runHook postBuild
  '' else
    buildPhase;

  checkPhase = if (checkPhase == null) then ''
    runHook preCheck
    nim_builder --phase:check
    runHook postCheck
  '' else
    checkPhase;

  installPhase = if (installPhase == null) then ''
    runHook preInstall
    nim_builder --phase:install
    runHook postInstall
  '' else
    installPhase;

  meta = meta // {
    platforms = meta.platforms or nim.meta.platforms;
    maintainers = (meta.maintainers or [ ]) ++ [ lib.maintainers.ehmry ];
  };
})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
