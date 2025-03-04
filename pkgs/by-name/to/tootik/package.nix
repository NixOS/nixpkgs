{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = version;
    hash = "sha256-2MD4WNeJ0XxbpMWelG+O25gXiTM5HeR1SJlN3gavg7I=";
  };

  vendorHash = "sha256-olXKx5uvdvms5oquZ21MsRFFVbtM/xi4Bk4QizwjjUs=";

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${version}" ];

  tags = [ "fts5" ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  meta = {
    description = "Federated nanoblogging service with a Gemini frontend";
    homepage = "https://github.com/dimkr/tootik";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "tootik";
  };
}
