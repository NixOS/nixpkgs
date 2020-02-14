{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    rev = "v${version}";
    sha256 = "1q0mpydh8h0zrml605q9r259y8584kbwcr9g4sqcb1n13b4d1sgp";
  };

  modSha256 = "1b6hz5a66hhlzpcv1badxr1b4nmk4lw0507d5jks7lqzvvwd0sxq";

  subPackages = [ "cmd/jsonnet" ];

  meta = with lib; {
    description = "An implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ nshalman ];
  };
}
