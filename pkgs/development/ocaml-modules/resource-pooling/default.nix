{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  logs,
  lwt,
}:

buildDunePackage (finalAttrs: {
  version = "1.3";
  pname = "resource-pooling";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "resource-pooling";
    tag = finalAttrs.version;
    hash = "sha256-DkuFBPobl0HJ/n8N9u086oxiHe8s/KiwQ5pR5n8oKLc=";
  };

  propagatedBuildInputs = [
    logs
    lwt
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/ocsigen/resource-pooling/";
    description = "Library for pooling resources like connections, threads, or similar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
