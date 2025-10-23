{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.19.6";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${version}";
    hash = "sha256-xbYmIH3dsZg2mL4coUwIAyQA5EhnTUOXs6Vu6ThfwUg=";
  };

  vendorHash = "sha256-hVhAtKW6O2wpmQS4l/O8ltt+aHxW6nDVpegOIip545c=";

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
