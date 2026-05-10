{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tdl";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xDCvZ6a7xW5kJ+3nsCQGASypzrosjihI0hlSobBWwj0=";
  };

  vendorHash = "sha256-dMuDmW3WtXU1Awuw7KKSCk1o/GKpBfsrqfvb3wVNGWw=";

  postPatch = ''
    rm go.work go.work.sum
    go mod edit -replace github.com/iyear/tdl/core=./core
    go mod edit -replace github.com/iyear/tdl/extension=./extension
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/iyear/tdl/pkg/consts.Version=${finalAttrs.version}"
  ];

  env.GOGC = "50";

  buildFlags = [ "-p=1" ];

  # Filter out the main executable
  subPackages = [ "." ];

  # Requires network access
  doCheck = false;

  meta = {
    description = "Telegram downloader/tools written in Golang";
    homepage = "https://github.com/iyear/tdl";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "tdl";
  };
})
