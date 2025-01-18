{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "5.16";
  pname = "watchdog";
  src = fetchzip {
    url = "mirror://sourceforge/watchdog/watchdog-${finalAttrs.version}.tar.gz";
    hash = "sha256-ecXsnPvAhlRB8jiTgK+i1j6m/0idNqmzjSqi6UGCydE=";
  };
  makeFlags = [
    "CONFIG_FILENAME:=${placeholder "out"}/etc/watchdog.conf"
  ];

  meta = with lib; {
    description = "Software watchdog for Linux";
    homepage = "https://sourceforge.net/projects/watchdog/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ n8henrie ];
    mainProgram = "watchdog";
  };
})
