{ lib
, fetchFromGitLab
, buildDunePackage
, lwt
}:

buildDunePackage rec {
  pname = "lwt-watcher";
  version = "0.1";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kaf7py02i0dn9rvrbzxh4ljfg059wc8xvm093m9wy7lsa68rax9";
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
