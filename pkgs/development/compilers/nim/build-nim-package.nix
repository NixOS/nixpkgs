{ lib, stdenv, nim1, nim2, nim_builder, defaultNimVersion ? 2 }:
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
    meta = { inherit (nim2.meta) maintainers platforms; };
  };

  inputsOverride = { depsBuildBuild ? [ ], nativeBuildInputs ? [ ]
    , requiredNimVersion ? defaultNimVersion, ... }:
    (if requiredNimVersion == 1 then {
      nativeBuildInputs = [ nim1 ] ++ nativeBuildInputs;
    } else if requiredNimVersion == 2 then {
      nativeBuildInputs = [ nim2 ] ++ nativeBuildInputs;
    } else
      throw "requiredNimVersion ${toString requiredNimVersion} is not valid")
    // {
      depsBuildBuild = [ nim_builder ] ++ depsBuildBuild;
    };

  composition = finalAttrs:
    let
      asFunc = x: if builtins.isFunction x then x else (_: x);
      prev = baseAttrs // (asFunc ((asFunc pkgArgs) finalAttrs)) baseAttrs;
    in prev // inputsOverride prev;

in stdenv.mkDerivation composition
