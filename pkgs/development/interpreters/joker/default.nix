{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "1.3.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "sha256-aBZ0KlXWKAF70xFxc+WWXucLPnxyaCxu97IYkPuKcCA=";
  };

  vendorHash = "sha256-k17BthjOjZs0WB88AVVIM00HcSZl2S5u8n9eB2NFdrk=";

  doCheck = false;

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/candid82/joker";
    description = "A small Clojure interpreter and linter written in Go";
    mainProgram = "joker";
    license = licenses.epl10;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
