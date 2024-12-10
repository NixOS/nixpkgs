{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    rev = version;
    hash = "sha256-v7+WDxGUWCrZMhm0TXMIZTQZTzHYNauX2LIOV3zz+9A=";
  };

  vendorHash = "sha256-wmyaTZX181w4Kiiw1sZ4NeIDY63PwW+ayvtwrLSiF24=";

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
