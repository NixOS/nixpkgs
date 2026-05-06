{
  lib,
  buildGo125Module,
  fetchFromGitHub,
}:

buildGo125Module (finalAttrs: {
  pname = "tidb";
  version = "8.5.6";

  src = fetchFromGitHub {
    owner = "pingcap";
    repo = "tidb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sQ5hialileLC/ZpXoy5zfSnLZAL1I4aiiQf+y5LPIK8=";
  };

  vendorHash = "sha256-YJ47tC1pp+hDMIiKyzROypk+zX76r+c5O9qD2OkVmgw=";

  ldflags = [
    "-X github.com/pingcap/tidb/pkg/parser/mysql.TiDBReleaseVersion=${finalAttrs.version}"
    "-X github.com/pingcap/tidb/pkg/util/versioninfo.TiDBEdition=Community"
  ];

  subPackages = [ "cmd/tidb-server" ];

  meta = {
    description = "Open-source, cloud-native, distributed, MySQL-Compatible database for elastic scale and real-time analytics";
    homepage = "https://pingcap.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Makuru ];
    mainProgram = "tidb-server";
  };
})
