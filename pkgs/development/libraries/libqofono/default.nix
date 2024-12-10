{
  lib,
  substituteAll,
  mkDerivation,
  fetchFromGitLab,
  mobile-broadband-provider-info,
  qmake,
  qtbase,
  qtdeclarative,
}:

mkDerivation rec {
  pname = "libqofono";
  version = "0.103";

  src = fetchFromGitLab {
    domain = "git.sailfishos.org";
    owner = "mer-core";
    repo = "libqofono";
    rev = version;
    sha256 = "1ly5aj412ljcjvhqyry6nhiglbzzhczsy1a6w4i4fja60b2m1z45";
  };

  patches = [
    (substituteAll {
      src = ./0001-NixOS-provide-mobile-broadband-provider-info-path.patch;
      inherit mobile-broadband-provider-info;
    })
    ./0001-NixOS-Skip-tests-they-re-shock-full-of-hardcoded-FHS.patch
  ];

  # Replaces paths from the Qt store path to this library's store path.
  postPatch = ''
    substituteInPlace src/src.pro \
      --replace /usr $out \
      --replace '$$[QT_INSTALL_PREFIX]' "$out" \
      --replace 'target.path = $$[QT_INSTALL_LIBS]' "target.path = $out/lib"

    substituteInPlace plugin/plugin.pro \
      --replace '$$[QT_INSTALL_QML]' $out'/${qtbase.qtQmlPrefix}'
  '';

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  meta = with lib; {
    description = "Library for accessing the ofono daemon, and declarative plugin for it";
    homepage = "https://git.sailfishos.org/mer-core/libqofono/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ samueldr ];
    platforms = platforms.linux;
  };
}
