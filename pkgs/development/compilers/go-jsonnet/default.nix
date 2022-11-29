{ lib, buildGoModule, fetchFromGitHub, fetchpatch, testers, go-jsonnet }:

buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FgQYnas0qkIedRAA8ApZXLzEylg6PS6+8zzl7j+yOeI=";
  };

  vendorSha256 = "sha256-j1fTOUpLx34TgzW94A/BctLrg9XoTtb3cBizhVJoEEI=";

  patches = [
    # See https://github.com/google/go-jsonnet/issues/653.
    (fetchpatch {
      url = "https://github.com/google/go-jsonnet/commit/5712f2ed2c8dfa685e4f1234eefc7690a580af6f.patch";
      hash = "sha256-/+6BlAaul4FoD7pq7yAy1xG78apEBuH2LC4fsfbugFQ=";
    })
  ];

  subPackages = [ "cmd/jsonnet*" ];

  passthru.tests.version = testers.testVersion {
    package = go-jsonnet;
    version = "v${version}";
  };

  meta = with lib; {
    description = "An implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ nshalman aaronjheng ];
    mainProgram = "jsonnet";
  };
}
