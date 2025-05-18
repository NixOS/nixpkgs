{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "thrift-ls";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "joyme123";
    repo = "thrift-ls";
    rev = "v${version}";
    hash = "sha256-QX4ChPjHIY0GtjqmZH5Q4veC+VnMntYIQvwwSds8UUo=";
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
}
