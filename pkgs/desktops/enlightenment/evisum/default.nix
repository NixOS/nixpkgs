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
  version = "2.0.7";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "5WpBdzAwpUn6Aen6ShqKB/smcddu0Znn54FYpZ3SlwY=";
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
