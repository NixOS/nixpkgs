{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tdl";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uVg4SXq+E+pzKFzCt7nn99sTCLj7CXaWnjIidKPA2Kk=";
  };

  vendorHash = "sha256-tg6GQ3SVDJnKUCrOuI+iJ/cJeiNNki9+ZF21r0t5rQA=";

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
