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
  pname = "ephoto";
  version = "1.6.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1lvhcs4ba8h3z78nyycbww8mj4cscb8k200dcc3cdy8vrvrp7g1n";
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
    description = "Image viewer and editor written using the Enlightenment Foundation Libraries";
    mainProgram = "ephoto";
    homepage = "https://www.smhouston.us/ephoto/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    teams = [ teams.enlightenment ];
  };
}
