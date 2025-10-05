{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tidb";
  version = "8.5.3";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    rev = "v${version}";
    sha256 = "sha256-2pg3UxzxzB4V4XhfmSxQCOn+NFqvp7DF+htIY3mtZ4s=";
  };

  vendorHash = "sha256-HXN2EkpN2ltBUB2HqSvUOgVTfs2zcTeHoxa5zpccc+A=";

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
