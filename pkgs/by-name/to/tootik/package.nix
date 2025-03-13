{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = version;
    hash = "sha256-BkMGozLr6yBj8TPhjJNUwH/SIC8qJ+HYne7CvJgbj3I=";
  };

  vendorHash = "sha256-l5u4ImpMASri+3ph/Q5gs0oWPAk81ZmFkNfiMnIHxuU=";

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
