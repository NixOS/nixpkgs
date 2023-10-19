{ lib, stdenv, nim, nim_builder }:
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
