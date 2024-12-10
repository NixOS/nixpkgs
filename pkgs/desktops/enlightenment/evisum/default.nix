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
  version = "0.6.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1ip3rmp0hcn0pk6lv089cayx18p1b2wycgvwpnf7ghbdxg7n4q15";
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

  meta = with lib; {
    description = "System and process monitor written with EFL";
    mainProgram = "evisum";
    homepage = "https://www.enlightenment.org";
    license = with licenses; [ isc ];
    platforms = platforms.linux;
    maintainers = teams.enlightenment.members;
  };
}
