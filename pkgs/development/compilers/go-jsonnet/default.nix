{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, testers
}:

let self = buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o/IjXskGaMhvQmTsAS745anGBMI2bwHf/EOEp57H8LU=";
  };

  patches = [
    (fetchpatch {
      name = "update-x-sys-for-go-1.18-on-aarch64-darwin.patch";
      url = "https://github.com/google/go-jsonnet/commit/7032dd729f7e684dcfb2574f4fe99499165ef9cb.patch";
      hash = "sha256-emUcuE9Q4qkXFXLyLvLHjzrKAaQhjcSWLNafABvHxhM=";
    })
  ];

  vendorHash = "sha256-H4vLVXpuPkECB15LHoS9N9IwUD7Fzccshwbo5hjeXXc=";

  doCheck = false;

  subPackages = [ "cmd/jsonnet*" ];

  passthru.tests.version = testers.testVersion {
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
