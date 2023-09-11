{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "1.3.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "sha256-D9maTCNNJ9ivj76SEjddFSYNu+RLEZG+3SgOWEAD7aU=";
  };

  vendorHash = "sha256-ioC7R5Pm2nmHXI+/ko1UoNJCvEFzvhZcAcVtaFECz2c=";

  doCheck = false;

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/candid82/joker";
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
