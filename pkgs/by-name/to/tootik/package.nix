{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = version;
    hash = "sha256-Onl64ps8rfLVnZYQ2KPzS+mslgeNz2wpJuabwsqhXlM=";
  };

  vendorHash = "sha256-GSi+sQz7kgp1YHEzH/Y7rOOEEhhvzd75cVhSow3URaU=";

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${version}" ];

  tags = [ "fts5" ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  meta = with lib; {
    description = "Federated nanoblogging service with a Gemini frontend";
    homepage = "https://github.com/dimkr/tootik";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "tootik";
  };
}
