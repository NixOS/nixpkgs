{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ticker";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "achannarasappa";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7yAmwyKIO0bMqNgTcdWcgBXPV/T7753z/x2KAB8W070=";
  };

  vendorHash = "sha256-XrZdv6QpR1HGN2o/Itbw+7hOkgVjzvx3jwlHeaJ2m0U=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/achannarasappa/ticker/cmd.Version=v${version}"
  ];

  # Tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Terminal stock ticker with live updates and position tracking";
    homepage = "https://github.com/achannarasappa/ticker";
    changelog = "https://github.com/achannarasappa/ticker/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben sarcasticadmin ];
    mainProgram = "ticker";
  };
}
