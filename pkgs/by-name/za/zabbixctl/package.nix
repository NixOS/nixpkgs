{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "zabbixctl";
  version = "unstable-2021-05-25";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = pname;
    rev = "872d73b12901b143898bffe3711b93a34ca75abe";
    sha256 = "sha256-fWT3cgIHjHcKwFDjWIf3BUUUaVZ7hyc2ibkpU+AsW0I=";
  };

  vendorHash = "sha256-BphQcPPmeNU7RDtaHJQxIoW8xxD86xWgqLBsLR08Tag=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Most effective way for operating in Zabbix Server";
    homepage = "https://github.com/kovetskiy/zabbixctl";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    mainProgram = "zabbixctl";
  };
}
