{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "starlark";
  version = "unstable-2023-03-02";

  src = fetchFromGitHub {
    owner = "google";
    repo = "starlark-go";
    rev = "4b1e35fe22541876eb7aa2d666416d865d905028";
    hash = "sha256-TqR8V9cypTXaXlKrAUpP2qE5gJ9ZanaRRs/LmVt/XEo=";
  };

  vendorHash = "sha256-mMxRw2VucXwKGQ7f7HM0GiQUExxN38qYZDdmEyxtXDA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/google/starlark-go";
    description = "An interpreter for Starlark, implemented in Go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
