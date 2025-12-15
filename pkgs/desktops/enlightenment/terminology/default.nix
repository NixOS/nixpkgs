{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  efl,
  nixosTests,
  directoryListingUpdater,
}:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.14.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "81QFcFGwXP+2meM4NqETXbHU7Yv5VPm1fcDpO8MHUU0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    efl
  ];

  postPatch = ''
    patchShebangs data/colorschemes/*.py
  '';

  passthru.tests.test = nixosTests.terminal-emulators.terminology;

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      matejc
      ftrvxmtrx
    ];
    teams = [ lib.teams.enlightenment ];
  };
}
