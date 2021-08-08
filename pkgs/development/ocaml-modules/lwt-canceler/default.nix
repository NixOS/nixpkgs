{ lib, fetchFromGitLab, buildDunePackage, lwt }:

buildDunePackage rec {
  pname = "lwt-canceler";
  version = "0.2";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "lwt-canceler";
    rev = "v${version}";
    sha256 = "07931486vg83sl1c268i0vyw61l8n8xs2krjsj43070zljqi8rf1";
  };
  useDune2 = true;

  propagatedBuildInputs = [
    lwt
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/lwt-canceler";
    description = "Cancellation synchronization object";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
