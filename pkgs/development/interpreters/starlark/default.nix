{ stdenv, lib, fetchFromGitHub, buildGoModule }:
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

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://github.com/google/starlark-go";
    description = "An interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
