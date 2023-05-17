{ lib, stdenv, nim, nim_builder }:

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
