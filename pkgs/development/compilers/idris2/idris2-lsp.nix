{
  lib,
  fetchFromGitHub,
  idris2Packages,
  makeWrapper,
}:

let
  globalLibrariesPath =
    let
      idrName = "idris2-${idris2Packages.idris2.version}";
    in
    lib.makeSearchPath idrName (
      [
        "\\$HOME/.nix-profile/lib/"
        "/run/current-system/sw/lib/"
        "${idris2Packages.idris2}"
      ]
      ++ idris2Packages.idris2.prelude
    );

  inherit (idris2Packages) idris2Api;
  lspLib = idris2Packages.buildIdris {
    ipkgName = "lsp-lib";
    version = "2025-08-14";
    src = fetchFromGitHub {
      owner = "idris-community";
      repo = "LSP-lib";
      rev = "ca77e80a392b8cfeee3aaeb150069957699cdb82";
      hash = "sha256-maXHx/OrflIdV7XPfDCRShUGZekLbLOSFQPHnL6DxnI=";
    };
    idrisLibraries = [ ];
  };

  lspPkg = idris2Packages.buildIdris {
    ipkgName = "idris2-lsp";
    version = "2025-09-10";
    src = fetchFromGitHub {
      owner = "idris-community";
      repo = "idris2-lsp";
      rev = "81344545c134c8e7105ecf1fdd7a1caae6647035";
      hash = "sha256-uYmg9Jd98RiO5SpRFox2xNAxY4nocPuK//zxuaIi/DM=";
    };
    idrisLibraries = [
      idris2Api
      lspLib
    ];

    nativeBuildInputs = [ makeWrapper ];
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
in
lspPkg.executable
