{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wiki-go";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "leomoon-studios";
    repo = "wiki-go";
    tag = "v${version}";
    hash = "sha256-R2z5+A1vY0N6RsFapUWj7kJwHYEuJuzX1dVZPaYIbks=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A modern, feature-rich, databaseless flat-file wiki platform built with Go";
    homepage = "https://github.com/leomoon-studios/wiki-go";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ paepcke ];
    mainProgram = "wiki-go";
  };
}
