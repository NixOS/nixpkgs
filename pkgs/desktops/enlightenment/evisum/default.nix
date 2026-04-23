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
  version = "1.2.3";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "McL4th987bozpaT3ESNCGBxSN+Fw5sW+MOFAiXYm1MI=";
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
