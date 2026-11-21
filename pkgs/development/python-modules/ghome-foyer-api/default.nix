{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio,
  hatchling,
  hatch-vcs,
  protobuf,
}:

buildPythonPackage rec {
  pname = "ghome-foyer-api";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "ghome-foyer-api";
    tag = "v${version}";
    hash = "sha256-wI1Df4t11g18jzUFzSkJvhrbW54BfXN1jvzvI7YSncg=";
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
    changelog = "https://github.com/KapJI/ghome-foyer-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hensoko
    ];
  };
}
