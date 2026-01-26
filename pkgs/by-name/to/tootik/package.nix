{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${version}";
    hash = "sha256-zkKkHzgIBHg0FH07KNr7jGNZU4QUbl6udoD7hLaDOL0=";
  };

  vendorHash = "sha256-UZQw63KPs7GzOv5Ls69DLqJqc/taWwC5UCYdNlq9fXc=";

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${version}" ];

  tags = [ "fts5" ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Federated nanoblogging service with a Gemini frontend";
    homepage = "https://github.com/dimkr/tootik";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "tootik";
  };
}
