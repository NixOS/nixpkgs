{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tasktimer";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CAqOsxmJxDgQRMx8cN23TajHd6BNiCFraFvhf5kKnzc=";
  };

  vendorHash = "sha256-Tk0yI/WFr0FV0AxJDStlP3XLem3v78ueuXyadhrLAog=";

  postInstall = ''
    mv $out/bin/tasktimer $out/bin/tt
  '';

  meta = with lib; {
    description = "Task Timer (tt) is a dead simple TUI task timer";
    homepage = "https://github.com/caarlos0/tasktimer";
    license = licenses.mit;
    maintainers = with maintainers; [
      abbe
      caarlos0
    ];
    mainProgram = "tt";
  };
}
