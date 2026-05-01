{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "yuhaiin";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "yuhaiin";
    repo = "yuhaiin";
    tag = "v${version}";
    hash = "sha256-9vrq2qKbBLObANzVWrP73BuhQdY0JSEdPci420lj3Fg=";
  };

  vendorHash = "sha256-FSm/oG0XkTqx93DrtVKoJAmIlkHNXEG20IanXuMxBgw=";

  subPackages = [ "cmd/yuhaiin" ];

  ldflags =
    let
      # https://github.com/yuhaiin/yuhaiin/blob/dbbcd93c3dce141a3323e03043d5d0eabe7252d1/makefile#L1
      module = "github.com/Asutorufa/yuhaiin/internal";
    in
    [
      "-s"
      "-w"
      "-X ${module}/version.Version=v${version}"
      "-X ${module}/version.GitCommit=${src.rev}"
      "-X ${module}/version.BuildDate=unknown"
    ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Proxy kit for Linux/Windows/MacOS";
    homepage = "https://github.com/yuhaiin/yuhaiin";
    changelog = "https://github.com/yuhaiin/yuhaiin/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "yuhaiin";
  };
}
