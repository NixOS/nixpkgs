{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.19.7";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${version}";
    hash = "sha256-8ZvLdEeuPOcjZnumy6bwu5jeloSKa+vvSnH7VH0BI6g=";
  };

  vendorHash = "sha256-UENMw+kuZHD4x+gON3g3zNsH0Z3weRKpJZh58IiazLw=";

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
