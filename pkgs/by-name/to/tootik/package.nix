{ lib, stdenv, buildGoModule, fetchFromGitHub, openssl }:

buildGoModule rec {
  pname = "tootik";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    rev = version;
    hash = "sha256-RcuioFb0+mvZupwgaCN6qbcOy7gHp9KjJxRwaPI55yo=";
  };

  vendorHash = "sha256-/52VjfoecXaML1cDRIEe1EQPYU8xeP9lu4lY3cMV3VE=";

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
