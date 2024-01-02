{ stdenv, lib, idris2
}:
# Usage: let
#          pkg = idris2Packages.buildIdris {
#            src = ...;
#            projectName = "my-pkg";
#            idrisLibraries = [ ];
#          };
#        in {
#          lib = pkg.library { withSource = true; };
#          bin = pkg.executable;
#        }
#
{ src
, projectName
, idrisLibraries # Other libraries built with buildIdris
, ... }@attrs:

let
  ipkgName = projectName + ".ipkg";
  idrName = "idris2-${idris2.version}";
  libSuffix = "lib/${idrName}";
  libDirs =
    lib.makeSearchPath libSuffix idrisLibraries;
  drvAttrs = builtins.removeAttrs attrs [ "idrisLibraries" ];

  sharedAttrs = {
    name = projectName;
    src = src;
    nativeBuildInputs = [ idris2 ];

    IDRIS2_PACKAGE_PATH = libDirs;

    configurePhase = ''
      runHook preConfigure
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      idris2 --build ${ipkgName}
      runHook postBuild
    '';
  };

in {
  executable = stdenv.mkDerivation (lib.attrsets.mergeAttrsList [
    sharedAttrs
    { installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        mv build/exec/* $out/bin
        runHook postInstall
      '';
    }
    drvAttrs
  ]);
  library = { withSource ? false }:
    let installCmd = if withSource then "--install-with-src" else "--install";
    in stdenv.mkDerivation (lib.attrsets.mergeAttrsList [
      sharedAttrs
      {
        installPhase = ''
          runHook preInstall
          mkdir -p $out/${libSuffix}
          export IDRIS2_PREFIX=$out/lib
          idris2 ${installCmd} ${ipkgName}
          runHook postInstall
        '';
      }
      drvAttrs
    ]);
}
