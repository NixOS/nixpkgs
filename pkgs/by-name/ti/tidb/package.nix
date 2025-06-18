{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tidb";
  version = "8.5.2";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    rev = "v${version}";
    sha256 = "sha256-6fXkNG+cQh4HCZj3ApmLUA+n5ViSVOyABoCwx0K8Ja4=";
  };

  vendorHash = "sha256-TLNa4ykczRronsKITPwVFOls8ql7xWXJvOibqYulC/Q=";

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
