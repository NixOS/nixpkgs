{ boost
, ecm
, kdeApp
, kdeWrapper
, kdepim-runtime
, kdesignerplugin
, kitemmodels
, lib
, mariadb
, postgresql
, shared_mime_info
}:

let
  unwrapped =
    kdeApp {
      name = "akonadi";
      meta = {
        description = "KDE PIM Storage Service";
        license = with lib.licenses; [ gpl2 ];
        homepage = http://pim.kde.org/akonadi;
        maintainers = with lib.maintainers; [ vandenoever ];
      };
      nativeBuildInputs = [
        ecm
      ];
      buildInputs = [
        boost
        kdesignerplugin
        kitemmodels
      ];
      propagatedBuildInputs = [
        mariadb
        postgresql
      ];
    };
in
kdeWrapper unwrapped
{
  targets = [
    "bin/akonadi_agent_launcher"
    "bin/akonadi_agent_server"
    "bin/akonadi_control"
    "bin/akonadi_rds"
    "bin/akonadictl"
    "bin/akonadiserver"
    "bin/asapcat"
  ];
  paths = [ kdepim-runtime ];
}
