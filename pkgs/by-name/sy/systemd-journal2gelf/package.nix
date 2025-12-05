{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "SystemdJournal2Gelf";
  version = "0-unstable-2023-03-10";

  src = fetchFromGitHub {
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
    rev = "863a15df5ed2d50365bb9c27424e3b118ce404c0";
    hash = "sha256-AwJq0xZAoIpBz9kGERfmZZTn28LbAKIl3gUsFKL3yvs=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    homepage = "https://github.com/parse-nl/SystemdJournal2Gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      fpletz
    ];
    mainProgram = "SystemdJournal2Gelf";
  };
}
