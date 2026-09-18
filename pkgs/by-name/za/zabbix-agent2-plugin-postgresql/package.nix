{
  lib,
  buildGoModule,
  fetchurl,
}:

buildGoModule (finalAttrs: {
  pname = "zabbix-agent2-plugin-postgresql";
  version = "7.4.14";

  src = fetchurl {
    url = "https://cdn.zabbix.com/zabbix-agent2-plugins/sources/postgresql/zabbix-agent2-plugin-postgresql-${finalAttrs.version}.tar.gz";
    hash = "sha256-H+WwJ9RrITeWKErMW+vcEG/Z2rAjbznVg/dK3ZM7j0I=";
  };

  vendorHash = null;

  meta = {
    description = "Required tool for Zabbix agent integrated PostgreSQL monitoring";
    mainProgram = "postgresql";
    homepage = "https://www.zabbix.com/integrations/postgresql";
    license =
      if (lib.versions.major finalAttrs.version >= "7") then
        lib.licenses.agpl3Only
      else
        lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ gador ];
    platforms = lib.platforms.linux;
  };
})
