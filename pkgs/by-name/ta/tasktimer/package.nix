{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tasktimer";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "tasktimer";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-B2kuAGY7qVvv+95DzFn78no1vofJGr0dw0kW2AIeJpo=";
  };

  vendorHash = "sha256-IviHbJvGyjwy1ovItvbxNV91OL2JM9Z2MKHexXEhrMU=";

  postInstall = ''
    mv $out/bin/tasktimer $out/bin/tt
  '';

  meta = {
    description = "Task Timer (tt) is a dead simple TUI task timer";
    homepage = "https://github.com/caarlos0/tasktimer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      abbe
      caarlos0
    ];
    mainProgram = "tt";
  };
})
