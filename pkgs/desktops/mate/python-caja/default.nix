{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, mate
, python3Packages
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "python-caja";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "181zcs1pi3762chm4xraqs8048jm7jzwnvgwla1v3z2nqzpp3xr1";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    python3Packages.wrapPython
  ];

  buildInputs = [
    gtk3
    mate.caja
    python3Packages.python
    python3Packages.pygobject3
  ];

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Python binding for Caja components";
    homepage = "https://github.com/mate-desktop/python-caja";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
