{ stdenv, lib, fetchFromGitHub, buildGoModule, fetchpatch }:
buildGoModule rec {
  pname = "starlark";
  version = "unstable-2022-08-17";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "f738f5508c12fe5a9fae44bbdf07a94ddcf5030e";
    sha256 = "sha256-nkQxwdP/lXEq5iiGy17mUTSMG6XiKAUJYfMDgbr10yM=";
  };

  vendorSha256 = "sha256-Kcjtaef//7LmUAIViyKv3gTK7kjynwJ6DwgGJ+pdbfM=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/google/starlark-go";
    description = "An interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
