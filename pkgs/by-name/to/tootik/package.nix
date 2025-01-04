{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = version;
    hash = "sha256-9R/3rvFJTXvIfJF698yZ0wMmsN2T3I/Kj1nfOOZoOkI=";
  };

  vendorHash = "sha256-ADor2SEEPkWZVwpNEeb8ijUPAA6jZfD7QXJIIZ6BdD0=";

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
