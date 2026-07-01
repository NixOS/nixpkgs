{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule (finalAttrs: {
  pname = "tootik";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqBeQQS5yU08eo9P/809yj19boFapQfgJLWOKcd8rD0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-owEZaIbucCmvynyf/jMQxxTx/CHh4UE6WoIUxFkWb+0=";

  subPackages = [ "cmd/tootik" ];

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${finalAttrs.version}" ];

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
})
