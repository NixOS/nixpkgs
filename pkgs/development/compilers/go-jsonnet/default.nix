{ lib, buildGoModule, fetchFromGitHub, testVersion }:

let self = buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    rev = "v${version}";
    sha256 = "sha256-o/IjXskGaMhvQmTsAS745anGBMI2bwHf/EOEp57H8LU=";
  };

  vendorSha256 = "sha256-fZBhlZrLcC4xj5uvb862lBOczGnJa9CceS3D8lUhBQo=";

  doCheck = false;

  subPackages = [ "cmd/jsonnet*" ];

  passthru.tests.version = testVersion {
    package = self;
    version = "v${version}";
  };

  meta = with lib; {
    description = "An implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ nshalman aaronjheng ];
    mainProgram = "jsonnet";
  };
};
in self
