{ lib, buildGoModule, fetchurl, pkg-config }:

buildGoModule rec {
  pname = "zabbix-agent2-plugin-postgresql";
  version = "6.4.15";

  src = fetchurl {
    url = "https://cdn.zabbix.com/zabbix-agent2-plugins/sources/postgresql/zabbix-agent2-plugin-postgresql-${version}.tar.gz";
    hash = "sha256-9N2xN7ckfBiwWcI+C4VeHDQVrWEaeKUcjfIw7GU7K9E=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Required tool for Zabbix agent integrated PostgreSQL monitoring";
    mainProgram = "postgresql";
    homepage = "https://www.zabbix.com/integrations/postgresql";
    license = licenses.asl20;
    maintainers = with maintainers; [ gador ];
    platforms = platforms.linux;
  };
}
