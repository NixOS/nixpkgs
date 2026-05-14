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

  npmDepsHash = "sha256-yri0sDDqek3HwLjPE0C43VRfemi5NCDLSZ3FJ8bwmdg=";

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
