{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtbase,
}:

mkDerivation rec {
  pname = "qtmpris";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "qtmpris";
    rev = version;
    hash = "sha256-kuM8hUdsa7N+eLDbwYw3ay+PWxg35zcTBOvGow1NlzI=";
  };

  postPatch = ''
    substituteInPlace src/src.pro \
      --replace '$$[QT_INSTALL_LIBS]'    "$out/lib" \
      --replace '$$[QT_INSTALL_HEADERS]' "$out/include" \
      --replace '$$[QMAKE_MKSPECS]'      "$out/mkspecs"
  '';

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
  ];

  meta = {
    description = "Qt and QML MPRIS interface and adaptor";
    homepage = "https://github.com/sailfishos/qtmpris";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
