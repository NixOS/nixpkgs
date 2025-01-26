{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

let
  version = "1.4.1";
in
buildGoModule {
  pname = "yajsv";
  version = version;

  src = fetchFromGitHub {
    owner = "neilpa";
    repo = "yajsv";
    rev = "v${version}";
    hash = "sha256-dp7PBN8yR+gPPUWA+ug11dUN7slU6CJAojuxt5eNTxA=";
  };

  vendorHash = "sha256-f45climGKl7HxD+1vz2TGqW/d0dqJ0RfvgJoRRM6lUk=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/yajsv -v > /dev/null
  '';

  meta = {
    description = "Yet Another JSON Schema Validator";
    homepage = "https://github.com/neilpa/yajsv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rycee ];
    mainProgram = "yajsv";
  };
}
