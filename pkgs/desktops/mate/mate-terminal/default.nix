{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, libxml2
, mate-desktop
, dconf
, vte
, pcre2
, wrapGAppsHook
, mateUpdateScript
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "mate-terminal";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "08mgxbviik2dwwnbclp0518wlag2fhcr6c2yadgcbhwiq4aff9vp";
  };

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    libxml2
    mate-desktop
    pcre2
    vte
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  passthru.tests.test = nixosTests.terminal-emulators.mate-terminal;

  meta = with lib; {
    description = "MATE desktop terminal emulator";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
