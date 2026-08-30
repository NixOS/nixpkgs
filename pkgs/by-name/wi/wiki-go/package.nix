{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wiki-go";
  version = "1.8.13";

  src = fetchFromGitHub {
    owner = "leomoon-studios";
    repo = "wiki-go";
    tag = "v${version}";
    hash = "sha256-o+sAaA48242hadFvBvE5nGxrUKdi2uQjwpGM5B/91pA=";
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
