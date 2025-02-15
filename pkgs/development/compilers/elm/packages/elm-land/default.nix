{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  testers,
  pkgs,
  elm-land,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "elm-land";
  version = "0.20.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/elm-land/-/elm-land-${version}.tgz";
    sha256 = "sha256-aMYdXLuzwiWcBykAs8DWHJLHg3NfW4dYv8kOwYuKwgk";  # compute the correct hash
  };

  npmDepsHash = "sha256-h7KKPXT6X9/0U+5b4owNfVgJtw3QriO++rCLcaBHoCM=";

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  postInstall = ''
    wrapProgram $out/bin/elm-land --prefix PATH : ${pkgs.elmPackages.elm}/bin
  '';

  dontNpmBuild = true;

  meta = {
    description = "A production-ready framework for building Elm applications.";
    mainProgram = "elm-land";
    homepage = "https://github.com/elm-land/elm-land";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      domenkozar
      zupo
    ];
  };
}
