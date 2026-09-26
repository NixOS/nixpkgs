{ lib, idris2Packages }:
let
  inherit (idris2Packages) idris2 buildIdris;
  apiPkg = buildIdris {
    inherit (idris2.unwrapped) src version;
    ipkgName = "idris2api";
    idrisLibraries = [ ];
    preBuild = ''
      export IDRIS2_PREFIX=$out/lib
      make src/IdrisPaths.idr
    '';

    meta = {
      description = "Idris2 Compiler API Library";
      homepage = "https://github.com/idris-lang/Idris2";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ mattpolzin ];
      inherit (idris2.meta) platforms;
    };
  };
in
apiPkg.library { }
