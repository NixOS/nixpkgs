{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    rev = "v${version}";
    sha256 = "17606gc75wnkm64am4hmlv7m3fy2hi8rnzadp6nrgpcd6rl26m83";
  };

  vendorSha256 = "0nsm4gsbbn8myz4yfi6m7qc3iizhdambsr18iks0clkdn3mi2jn1";

  subPackages = [ "cmd/jsonnet" "cmd/jsonnetfmt" ];

  meta = with lib; {
    description = "An implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ nshalman ];
  };
}
