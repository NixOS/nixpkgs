{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "thrift-ls";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "joyme123";
    repo = "thrift-ls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ts0zy/wBjZTm71Umk46KBkdbUm/Akf/KXdoKp8G95ks=";
  };

  vendorHash = "sha256-SGCJ12BxjFUQ7bnaNY0bvrrtm2qNNrwYKKfNEi1lPco=";

  postInstall = ''
    mv $out/bin/thrift-ls $out/bin/thriftls
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Thrift Language Server";
    homepage = "https://github.com/joyme123/thrift-ls";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      callumio
      hughmandalidis
    ];
    mainProgram = "thriftls";
  };
})
