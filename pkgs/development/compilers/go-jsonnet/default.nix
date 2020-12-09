{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    rev = "v${version}";
    sha256 = "1rprs8l15nbrx4dw4pdg81c5l22zhj80pl4zwqgsm4113wyyvc98";
  };

  vendorSha256 = "0nsm4gsbbn8myz4yfi6m7qc3iizhdambsr18iks0clkdn3mi2jn1";

  doCheck = false;

  subPackages = [ "cmd/jsonnet" "cmd/jsonnetfmt" ];

  meta = with lib; {
    description = "An implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ nshalman ];
  };
}
