{ lib, stdenv, buildGoModule, fetchFromGitHub, openssl }:

buildGoModule rec {
  pname = "tootik";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    rev = version;
    hash = "sha256-aAIyEUeIZvDbWfUcfcETGrB3Md8GqRB8hvRBUtMU5Zs=";
  };

  vendorHash = "sha256-kAnGMNBWqH37QETnn2ncp7qOaCSx6Xd4HCFhCehh/kU=";

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${version}" ];

  tags = [ "fts5" ];

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = {
    description = "Federated nanoblogging service with a Gemini frontend";
    homepage = "https://github.com/dimkr/tootik";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "tootik";
  };
}
