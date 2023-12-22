{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "1.3.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "sha256-TaNuw84VCC1s2I7rmTdVKTrpT/nTrb+45haEFWf6S7k=";
  };

  vendorHash = "sha256-rxWYNGFbFUKjy232DOhVlh341GV2VKLngJKM+DEd27o=";

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
