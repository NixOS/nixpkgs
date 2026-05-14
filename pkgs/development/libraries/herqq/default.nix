{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  wrapQtAppsHook,
  qtmultimedia,
  qtbase,
}:

stdenv.mkDerivation rec {
  version = "unstable-20-06-26";
  pname = "herqq";

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
  ];

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${src.name}/herqq";
  src = fetchFromGitHub {
    owner = "ThomArmax";
    repo = "HUPnP";
    rev = "c8385a8846b52def7058ae3794249d6b566a41fc";
    sha256 = "FxN/QlLB3sZ6Vn/9VIKNUntX/B4+crQZ7t760pwFqY8=";
  };

  meta = {
    homepage = "http://herqq.org";
    description = "Software library for building UPnP devices and control points";
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
