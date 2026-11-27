{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tparse";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "mfridman";
    repo = "tparse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ecq5OHNXQOkTyNZ2bvP4hBuIdWT/TkUQoXxHGqf69+A=";
  };

  vendorHash = "sha256-dV6roD9wTEiRmKAnAgbgGYrf7emwOI3AAFoEDiNnVZE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "CLI tool for summarizing go test output. Pipe friendly. CI/CD friendly";
    mainProgram = "tparse";
    homepage = "https://github.com/mfridman/tparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ obreitwi ];
  };
})
