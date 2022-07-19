{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, gtk3
, libmpc
, libxml2
, mpfr
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-calc";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mddfh9ixhh60nfgx5kcprcl9liavwqyina11q3pnpfs3n02df3y";
  };

  nativeBuildInputs = [
    gettext
    itstool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libmpc
    libxml2
    mpfr
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Calculator for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
