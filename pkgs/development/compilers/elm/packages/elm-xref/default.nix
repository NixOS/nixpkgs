{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  elmPackages,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-xref";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "zwilias";
    repo = "elm-xref";
    tag = finalAttrs.version;
    hash = "sha256-J58NTSMo2uxpWFnPX+AGHVAqQOiRfgBxYzis/PZp1MA=";
  };

  npmDepsHash = "sha256-LZynUf2M+g31mia41jw7vmGNugUUUAX/TehDxQ7j+YY=";

  nativeBuildInputs = [
    elmPackages.elm
  ];

  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "elm";

  postConfigure =
    (elmPackages.fetchElmDeps {
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      registryDat = ./registry.dat;
    })
    + ''
      ln -sf ${lib.getExe elmPackages.elm} node_modules/.bin/elm
    '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross referencing tool for Elm";
    homepage = "https://github.com/zwilias/elm-xref";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-xref";
  };
})
