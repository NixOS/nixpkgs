{ lib
, stdenv
, fetchurl
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-common";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "014wpfqpqmfkzv81paap4fz15mj1gsyvaxlrfqsp9a3yxw4f7jaf";
  };

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Common files for development of MATE packages";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
