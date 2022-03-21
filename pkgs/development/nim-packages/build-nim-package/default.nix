{ lib, stdenv, nim, nim_builder }:

{ strictDeps ? true, nativeBuildInputs ? [ ], configurePhase ? null
, buildPhase ? null, checkPhase ? null, installPhase ? null, meta ? { }, ...
}@attrs:

stdenv.mkDerivation (attrs // {
  inherit strictDeps;
  nativeBuildInputs = [ nim nim_builder ] ++ nativeBuildInputs;

  configurePhase = if isNull configurePhase then ''
    runHook preConfigure
    export NIX_NIM_BUILD_INPUTS=''${pkgsHostTarget[@]} $NIX_NIM_BUILD_INPUTS
    nim_builder --phase:configure
    runHook postConfigure
  '' else
    configurePhase;

  buildPhase = if isNull buildPhase then ''
    runHook preBuild
    nim_builder --phase:build
    runHook postBuild
  '' else
    buildPhase;

  checkPhase = if isNull checkPhase then ''
    runHook preCheck
    nim_builder --phase:check
    runHook postCheck
  '' else
    checkPhase;

  installPhase = if isNull installPhase then ''
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
