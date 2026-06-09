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
  version = "2.0.10";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "ipp0Yv6uOcEnymkq6A534/pch8Eb2v7E38BgT99XNB4=";
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
    homepage = "https://git.enlightenment.org/enlightenment/evisum";
    license = with lib.licenses; [ isc ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.enlightenment ];
  };
}
