{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "lwt-watcher";
  version = "0.2";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "lwt-watcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-35Z73bSzEEgTabNH2cD9lRdDczsyIMZR2ktyKx4aN9k=";
  };

  propagatedBuildInputs = [
    lwt
  ];

  doCheck = true;

  meta = {
    description = "One-to-many broadcast in Lwt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
})
