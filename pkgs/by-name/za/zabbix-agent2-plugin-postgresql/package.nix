{
  lib,
  buildGoModule,
  fetchurl,
}:

buildGoModule rec {
  pname = "zabbix-agent2-plugin-postgresql";
  version = "7.0.2";

  src = fetchurl {
    url = "https://cdn.zabbix.com/zabbix-agent2-plugins/sources/postgresql/zabbix-agent2-plugin-postgresql-${version}.tar.gz";
    hash = "sha256-2+P0a74flxWIpZaII+V04G/szFUrnnIy+f8LfDewcx0=";
  };

  vendorHash = null;

  meta = {
    description = "Required tool for Zabbix agent integrated PostgreSQL monitoring";
    mainProgram = "postgresql";
    homepage = "https://www.zabbix.com/integrations/postgresql";
    license =
      if (lib.versions.major version >= "7") then lib.licenses.agpl3Only else lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ gador ];
    platforms = lib.platforms.linux;
  };
}
