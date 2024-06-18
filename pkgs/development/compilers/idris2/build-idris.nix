{ stdenv, lib, idris2, makeWrapper
}:
# Usage: let
#          pkg = idris2Packages.buildIdris {
#            src = ...;
#            ipkgName = "my-pkg";
#            idrisLibraries = [ ];
#          };
#        in {
#          lib = pkg.library { withSource = true; };
#          bin = pkg.executable;
#        }
#
{ src
, ipkgName
, version ? "unversioned"
, idrisLibraries # Other libraries built with buildIdris
, ... }@attrs:

let
  propagate = libs: lib.unique (lib.concatMap (nextLib: [nextLib] ++ nextLib.propagatedIdrisLibraries) libs);
  ipkgFileName = ipkgName + ".ipkg";
  idrName = "idris2-${idris2.version}";
  libSuffix = "lib/${idrName}";
  propagatedIdrisLibraries = propagate idrisLibraries;
  libDirs =
    (lib.makeSearchPath libSuffix propagatedIdrisLibraries) +
    ":${idris2}/${idrName}";
  supportDir = "${idris2}/${idrName}/lib";
  drvAttrs = builtins.removeAttrs attrs [
    "ipkgName"
    "idrisLibraries"
  ];

  derivation = stdenv.mkDerivation (finalAttrs:
    drvAttrs // {
      pname = ipkgName;
      inherit version;
      src = src;
      nativeBuildInputs = [ idris2 makeWrapper ] ++ attrs.nativeBuildInputs or [];
      buildInputs = propagatedIdrisLibraries ++ attrs.buildInputs or [];

      IDRIS2_PACKAGE_PATH = libDirs;

      buildPhase = ''
        runHook preBuild
        idris2 --build ${ipkgFileName}
        runHook postBuild
      '';

      passthru = {
        inherit propagatedIdrisLibraries;
      };

      shellHook = ''
        export IDRIS2_PACKAGE_PATH="${finalAttrs.IDRIS2_PACKAGE_PATH}"
      '';
    }
  );

in {
  executable = derivation.overrideAttrs {
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      scheme_app="$(find ./build/exec -name '*_app')"
      if [ "$scheme_app" = ''' ]; then
        mv -- build/exec/* $out/bin/
        chmod +x $out/bin/*
        # ^ remove after Idris2 0.8.0 is released. will be superfluous:
        # https://github.com/idris-lang/Idris2/pull/3189
      else
        cd build/exec/*_app
        rm -f ./libidris2_support.so
        for file in *.so; do
          bin_name="''${file%.so}"
          mv -- "$file" "$out/bin/$bin_name"
          wrapProgram "$out/bin/$bin_name" \
            --prefix LD_LIBRARY_PATH : ${supportDir} \
            --prefix DYLD_LIBRARY_PATH : ${supportDir}
        done
      fi
      runHook postInstall
    '';
  };

  library = { withSource ? false }:
    let installCmd = if withSource then "--install-with-src" else "--install";
    in derivation.overrideAttrs {
      installPhase = ''
        runHook preInstall
        mkdir -p $out/${libSuffix}
        export IDRIS2_PREFIX=$out/lib
        idris2 ${installCmd} ${ipkgFileName}
        runHook postInstall
      '';
    };
}
