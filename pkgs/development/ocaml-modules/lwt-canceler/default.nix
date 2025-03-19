{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  lwt,
}:

buildDunePackage rec {
  pname = "lwt-canceler";
  version = "0.3";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "lwt-canceler";
    rev = "v${version}";
    sha256 = "1xbb7012hp901b755kxmfgg293rz34rkhwzg2z9i6sakwd7i0h9p";
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
