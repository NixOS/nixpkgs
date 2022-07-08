{ stdenv, lib, fetchFromGitHub, buildGoModule, fetchpatch }:
buildGoModule rec {
  pname = "starlark";
  version = "unstable-2022-03-02";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "5411bad688d12781515a91cc032645331b4fc302";
    sha256 = "sha256-JNsGyGlIVMS5w0W4jHVsrPqqNms3Xfpa4n/XcEWqt6I=";
  };

  vendorSha256 = "sha256-lgL5o3MQfZekZ++BNESwV0LeoTxwEZfziQAe99zm4RY=";

  patches = [
    # Fix floating point imprecision issue in the test suite.
    # https://github.com/google/starlark-go/pull/409
    (fetchpatch {
      url = "https://github.com/google/starlark-go/commit/be6ed3bfcc376e5bf6fe2257ae89ddfb00d14e2c.patch";
      sha256 = "sha256-A0tHPso6SfFn73kICcA9/5n3JHd7hMdQMGty+4L6T4k=";
    })
  ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/google/starlark-go";
    description = "An interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
