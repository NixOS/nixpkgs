{ lib, fetchFromGitHub, idris2Packages, makeWrapper }:

let
  globalLibraries = let
    idrName = "idris2-${idris2Packages.idris2.version}";
    libSuffix = "lib/${idrName}";
  in [
    "\\$HOME/.nix-profile/lib/${idrName}"
    "/run/current-system/sw/lib/${idrName}"
    "${idris2Packages.idris2}/${idrName}"
  ];
  globalLibrariesPath = builtins.concatStringsSep ":" globalLibraries;

  idris2Api = idris2Packages.idris2Api { };
  lspLib = (idris2Packages.buildIdris {
    ipkgName = "lsp-lib";
    version = "2024-01-21";
    src = fetchFromGitHub {
     owner = "idris-community";
     repo = "LSP-lib";
     rev = "03851daae0c0274a02d94663d8f53143a94640da";
     hash = "sha256-ICW9oOOP70hXneJFYInuPY68SZTDw10dSxSPTW4WwWM=";
    };
    idrisLibraries = [ ];
  }).library { };

  lspPkg = idris2Packages.buildIdris {
    ipkgName = "idris2-lsp";
    version = "2024-01-21";
    src = fetchFromGitHub {
       owner = "idris-community";
       repo = "idris2-lsp";
       rev = "a77ef2d563418925aa274fa29f06880dde43f4ec";
       hash = "sha256-zjfVfkpiQS9AdmTfq0hYRSelJq5Caa9VGTuFLtSvl5o=";
    };
    idrisLibraries = [idris2Api lspLib];

    buildInputs = [makeWrapper];
    postInstall = ''
      wrapProgram $out/bin/idris2-lsp \
        --suffix IDRIS2_PACKAGE_PATH ':' "${globalLibrariesPath}"
    '';

    meta = with lib; {
      description = "Language Server for Idris2";
      mainProgram = "idris2-lsp";
      homepage = "https://github.com/idris-community/idris2-lsp";
      license = licenses.bsd3;
      maintainers = with maintainers; [ mattpolzin ];
    };
  };
in lspPkg.executable
