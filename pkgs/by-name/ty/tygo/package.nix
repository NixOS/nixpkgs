{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tygo";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "gzuidhof";
    repo = "tygo";
    rev = "v${version}";
    hash = "sha256-W2PgBcbkreP61QtAuOZ+VHUUZ4Mhe++1SK1p4Tg4Ack=";
  };

  vendorHash = "sha256-E73yqGhPzZA/1xTYGvTBy0/b4SE9hzx+gdhjX3ClE/Y=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  meta = {
    description = "Generate Typescript types from Golang source code";
    homepage = "https://github.com/gzuidhof/tygo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexymantha ];
    mainProgram = "tygo";
  };
}
