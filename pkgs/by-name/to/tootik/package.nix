{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = version;
    hash = "sha256-uq0mDlJ5NPXw1fsNcoyTbqqpZsYDkX8OSdZ5ToO0rYQ=";
  };

  vendorHash = "sha256-p/pgoGzrukd4mzzoyLI9g6vL4k+lTnMZOha1KrYjHJ0=";

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
