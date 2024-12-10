{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, efl
, directoryListingUpdater
}:

stdenv.mkDerivation rec {
  pname = "evisum";
  version = "0.6.1";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "gy8guN4T4pCJCBAmfPQe2Ey7DITi4goU9ng2MmEtrbk=";
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
