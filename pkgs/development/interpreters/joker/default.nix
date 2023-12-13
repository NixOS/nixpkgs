{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "1.3.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "sha256-9SsSXLZFwqsAeWFGsba8OG9bdmfQjn6qQHHQK6IdHK8=";
  };

  vendorHash = "sha256-VRQUbGJTC2v8w/l4iaNn3vPX3AdV9Likp2nuG0PQieU=";

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
