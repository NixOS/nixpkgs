{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  lwt,
  ptime,
}:

buildDunePackage (finalAttrs: {
  pname = "lwt-exit";
  version = "1.0";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "lwt-exit";
    tag = finalAttrs.version;
    hash = "sha256-bQniNH2PGpOQFzAIp+tkOZUW4IA5jaxkTFKrIOsa5sw=";
  };

  propagatedBuildInputs = [
    lwt
    ptime
  ];

  # for some reason this never exits
  doCheck = false;

  meta = {
    description = "Opinionated clean-exit and signal-handling library for Lwt programs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
})
