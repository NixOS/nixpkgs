{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, shared_mime_info
, kitemviews
}:

kdeApp {
  name = "akonadi";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  propagatedbuildInputs = [
    kitemviews
    shared_mime_info
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

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
