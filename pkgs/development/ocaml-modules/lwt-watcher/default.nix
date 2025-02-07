{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  lwt,
}:

buildDunePackage rec {
  pname = "lwt-watcher";
  version = "0.2";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-35Z73bSzEEgTabNH2cD9lRdDczsyIMZR2ktyKx4aN9k=";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    lwt
  ];

  doCheck = true;

  meta = {
    description = "One-to-many broadcast in Lwt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
