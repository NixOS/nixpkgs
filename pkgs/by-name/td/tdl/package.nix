{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "tdl";
  version = "0.20.4";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hYCxzkNJiGBLO2ZdDWJ9r4b5QZ/jBElFGNfx00JboGM=";
  };

  vendorHash = "sha256-nKuKmScnZLYL0SzFz8XfNOtYfoMuXYDZ+aKzH+2HYRk=";

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
