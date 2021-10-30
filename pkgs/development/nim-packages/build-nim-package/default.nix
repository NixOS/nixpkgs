{ lib, stdenv, nim, nim_builder }:

{ strictDeps ? true, nativeBuildInputs ? [ ], configurePhase ? null
, buildPhase ? null, checkPhase ? null, installPhase ? null, meta ? { }, ...
}@attrs:

stdenv.mkDerivation (attrs // {
  inherit strictDeps;
  nativeBuildInputs = [ nim nim_builder ] ++ nativeBuildInputs;

  configurePhase = if isNull configurePhase then ''
    runHook preConfigure
    find $NIX_BUILD_TOP -name .attrs.json
    nim_builder --phase:configure
    runHook postConfigure
  '' else
    buildPhase;

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
    maintainers = (meta.maintainers or [ ]) ++ [ lib.maintainers.ehmry ];
  };
})
