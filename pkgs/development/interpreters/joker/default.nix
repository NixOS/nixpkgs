{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "1.1.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "sha256-ERkK4T+nUTf18OoEctSugeK4i/f6k0naBKxzn+6pe38=";
  };

  vendorSha256 = "sha256-AYoespfzFLP/jIIxbw5K653wc7sSfLY8K7di8GZ64wA=";

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
