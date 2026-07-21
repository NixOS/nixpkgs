{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "tendermint";
  version = "0.35.9";

  src = fetchFromGitHub {
    owner = "tendermint";
    repo = "tendermint";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3tggW+M3vZChDT1g77W5M3hchEN6pTSVvkrZda6ZTCY=";
  };

  vendorHash = "sha256-/enY0qERFzAIJNcuw1djRGoAcmtz7R5Ikvlts0f7rLc=";

  subPackages = [ "cmd/tendermint" ];

  preBuild = ''
    makeFlagsArray+=(
      "-ldflags=-s -w -X github.com/tendermint/tendermint/version.GitCommit=${finalAttrs.src.rev}"
    )
  '';

  meta = {
    description = "Byzantine-Fault Tolerant State Machines. Or Blockchain, for short";
    homepage = "https://tendermint.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexfmpe ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "tendermint";
  };
})
