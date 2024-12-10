{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gokrazy";
  version = "unstable-2023-08-12";

  src = fetchFromGitHub {
    owner = "gokrazy";
    repo = "tools";
    rev = "23cde3b0d858497a63c21e93ad30859bf197995f";
    hash = "sha256-oqtkC04TaOkcXkGAZzATCBA0XnFsx7bSGP9ODyhgAxQ=";
  };

  vendorHash = "sha256-rIIMqYMgLNCMYEH+44v79i8yGbHDmUY21X3h1E2jP9Q=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  subPackages = [ "cmd/gok" ];

  meta = with lib; {
    description = "Turn your Go program(s) into an appliance running on the Raspberry Pi 3, Pi 4, Pi Zero 2 W, or amd64 PCs!";
    homepage = "https://github.com/gokrazy/gokrazy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ shayne ];
    mainProgram = "gok";
  };
}
