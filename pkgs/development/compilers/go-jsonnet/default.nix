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

  vendorSha256 = "1vdv0nq31mjprxzxf8x0diaigissy07vnm338h8jrk5i74x5by39";

  subPackages = [ "cmd/jsonnet" ];

  meta = with lib; {
    description = "An implementation of Jsonnet in pure Go";
    homepage = "https://github.com/google/go-jsonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ nshalman ];
  };
}