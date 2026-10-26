{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio,
  hatchling,
  hatch-vcs,
  protobuf,
}:

buildPythonPackage (finalAttrs: {
  pname = "ghome-foyer-api";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "ghome-foyer-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hIprnkfAUbKoAp++sxu+T7MuGqLKOM1N1hqGBDOSo3k=";
  };

  buildInputs = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    grpcio
    protobuf
  ];

  doCheck = false; # no tests

  pythonRelaxDeps = [ "protobuf" ];

  meta = {
    description = "Generated Python protobuf stubs for Google Home internal API";
    homepage = "https://github.com/KapJI/ghome-foyer-api";
    changelog = "https://github.com/KapJI/ghome-foyer-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hensoko
    ];
  };
})
