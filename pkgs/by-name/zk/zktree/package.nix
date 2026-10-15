{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zktree";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "alirezameskin";
    repo = "zktree";
    rev = finalAttrs.version;
    hash = "sha256-aTpyRmHbHAs6HuX7c4Y5dDTnoLwoZbwMjj7/wsM0iIc=";
  };

  cargoHash = "sha256-h6tDAcWOS1MikPMXiH0eQzkQIqVEC8rSsWbufGsh1CI=";

  meta = {
    description = "Small tool to display Znodes in Zookeeper in tree structure";
    homepage = "https://github.com/alirezameskin/zktree";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ alirezameskin ];
    mainProgram = "zktree";
  };
})
