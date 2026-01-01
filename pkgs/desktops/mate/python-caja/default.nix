{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  caja,
  gtk3,
  python3Packages,
<<<<<<< HEAD
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
=======
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "python-caja";
  version = "1.28.0";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/python-caja-${finalAttrs.version}.tar.xz";
=======
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/python-caja";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Python binding for Caja components";
    homepage = "https://github.com/mate-desktop/python-caja";
    license = [ lib.licenses.gpl2Plus ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})
=======
  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Python binding for Caja components";
    homepage = "https://github.com/mate-desktop/python-caja";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
