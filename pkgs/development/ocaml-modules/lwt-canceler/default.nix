{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "lwt-canceler";
  version = "0.3";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "lwt-canceler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N0EQT+NTaRPTF+9zODMZP48k3nO1z1LOCiBdKAI4a/U=";
  };

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
})
