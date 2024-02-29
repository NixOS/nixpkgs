{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, qttools
, qtbase
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dfl-login1";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "login1";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3BiYN8CdRTvopQuEfpemfAM3pQ7DAlCvZepBEf7IXiU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    qttools
  ];

  buildInputs = [
    qtbase
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  dontWrapQtApps = true;

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/login1";
    description = "Implementation of systemd/elogind for DFL";
    maintainers = with lib.maintainers; [ sreehax ];
    license = lib.licenses.gpl3Only;
  };
})
