{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jsonnet";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-jsonnet";
    rev = "v${version}";
    sha256 = "0l6cwky2xl7m8nnc9abp76bhkdcf2ldbbv3r8p30xv2yr5wd1j8i";
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
