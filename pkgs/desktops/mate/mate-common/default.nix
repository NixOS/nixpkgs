{
  lib,
  stdenvNoCC,
  fetchurl,
  mateUpdateScript,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mate-common";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "QrfCzuJo9x1+HBrU9pvNoOzWVXipZyIYfGt2N40mugo=";
  };

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Common files for development of MATE packages";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
