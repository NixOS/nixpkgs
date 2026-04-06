{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  efl,
  directoryListingUpdater,
}:

stdenv.mkDerivation rec {
  pname = "evisum";
  version = "1.2.1";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "XuND4zidLkkah3kYYBc7ZLG4r3QvnKpc34NFxA7NR9c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    efl
  ];

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    description = "System and process monitor written with EFL";
    mainProgram = "evisum";
    homepage = "https://www.enlightenment.org";
    license = with lib.licenses; [ isc ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.enlightenment ];
  };
}
