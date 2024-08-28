{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "tparse";
  version = "0.14.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mfridman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-siw9GihPo6f+OWKvSx0kqC919BuL/YoUI2dUBwTF19U=";
  };

  vendorHash = "sha256-j+1B2zWONjFEGoyesX0EW964kD33Jy3O1aB1WEwlESA=";

  meta = {
    description = "CLI tool for summarizing go test output. Pipe friendly. CI/CD friendly";
    mainProgram = "tparse";
    homepage = "https://github.com/mfridman/tparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ obreitwi ];
  };
}
