{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:

buildGoModule rec {
  pname = "tenderly";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "Tenderly";
    repo = "tenderly-cli";
    tag = "v${version}";
    hash = "sha256-7l6Od/U8vVZ1oKlmvMAUBQIT78aYwf7q3IjTbpmw1Nk=";
  };

  vendorHash = "sha256-HIR9iNcS5LUJyae3oz7d8enB6J8CDKRnsTnYUvOJYSI=";

  meta = {
    description = "Suite of development tools that allows you to debug, monitor and track the execution of your smart contracts";
    homepage = "https://github.com/Tenderly/tenderly-cli";
    changelog = "https://github.com/Tenderly/tenderly-cli/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ codebam ];
    mainProgram = "tenderly";
  };
}
