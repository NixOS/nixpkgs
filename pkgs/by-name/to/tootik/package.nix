{ lib, stdenv, buildGoModule, fetchFromGitHub, openssl }:

buildGoModule rec {
  pname = "tootik";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    rev = version;
    hash = "sha256-roB1mrhq9LQcdi7ynPzI9UmeawSw9fX7jl3bb6+ygfM=";
  };

  vendorHash = "sha256-Lsc8nK4I1gZEW7RbEapHr3IJ6wTATLElX3XfNX1LwvM=";

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${version}" ];

  tags = [ "fts5" ];

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = {
    description = "A federated nanoblogging service with a Gemini frontend";
    homepage = "https://github.com/dimkr/tootik";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "tootik";
  };
}
