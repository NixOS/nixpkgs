{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  caja,
  gtk3,
  python3Packages,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "python-caja";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sFbCOdvf4z7QzIQx+zUAqTj3h7Weh19f+TV4umb2gNY=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    python3Packages.wrapPython
  ];

  buildInputs = [
    caja
    gtk3
    python3Packages.python
    python3Packages.pygobject3
  ];

  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Python binding for Caja components";
    homepage = "https://github.com/mate-desktop/python-caja";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
