{ boost
, extra-cmake-modules
, kdeApp
, kdesignerplugin
, kitemmodels
, lib
, makeQtWrapper
, mariadb
, postgresql
, shared_mime_info
}:

kdeApp {
  name = "akonadi";
  meta = {
    description = "KDE PIM Storage Service";
    license = with lib.licenses; [ gpl2 ];
    homepage = http://pim.kde.org/akonadi;
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    makeQtWrapper
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

  postInstall = ''
    wrapQtProgram "$out/bin/akonadi_agent_launcher"
    wrapQtProgram "$out/bin/akonadi_agent_server"
    wrapQtProgram "$out/bin/akonadi_control"
    wrapQtProgram "$out/bin/akonadi_rds"
    wrapQtProgram "$out/bin/akonadictl"
    wrapQtProgram "$out/bin/akonadiserver"
    wrapQtProgram "$out/bin/asapcat"
  '';
}
