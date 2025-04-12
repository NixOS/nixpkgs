{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "xurls";
  version = "2.5.0-unstable-2024-11-03";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "xurls";
    rev = "7c973a26c7bd6ecd8d86bb435d93ff98df2710fa";
    sha256 = "sha256-jZmlM9rs+N0ks7msmb3eJ96aTYp0qUo/1bgLAgHnvSo=";
  };

  vendorHash = "sha256-W6Z1E6a+qBdOuyHoiT6YA+CAJHBJ0FTYH8AntiKvVBY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Extract urls from text";
    homepage = "https://github.com/mvdan/xurls";
    maintainers = with maintainers; [ koral ];
    license = licenses.bsd3;
  };
}
