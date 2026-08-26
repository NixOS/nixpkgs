{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "taskbook";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "klaudiosinani";
    repo = "taskbook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LL9v7uRYbthK0riN6DKannABlhNWaG880Yp8egmwBJ4=";
  };

  dontNpmBuild = true;
  dontNpmPrune = true;

  npmDepsHash = "sha256-4YZHn7CPQHoGfy0CqD96btlctJfIT3NnUQ47PWot6Ok=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  meta = {
    description = "Tasks, boards & notes for the command-line habitat";
    homepage = "https://github.com/klaudiosinani/taskbook";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ skohtv ];
    mainProgram = "tb";
  };
})
