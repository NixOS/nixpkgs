{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tidb";
  version = "8.5.4";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    rev = "v${version}";
    sha256 = "sha256-8YlN49XPplEAk1RwqB+2fXyTMIAFXt5W0CGOE0hc3PQ=";
  };

  vendorHash = "sha256-fVY34aZCaxGh6OXV9oEkdEtJpXqyaQjxH0v6Xfpokz4=";

  ldflags = [
    "-X github.com/pingcap/tidb/pkg/parser/mysql.TiDBReleaseVersion=${version}"
    "-X github.com/pingcap/tidb/pkg/util/versioninfo.TiDBEdition=Community"
  ];

  subPackages = [ "cmd/tidb-server" ];

  meta = with lib; {
    description = "Open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ Makuru ];
    mainProgram = "tidb-server";
  };
}
