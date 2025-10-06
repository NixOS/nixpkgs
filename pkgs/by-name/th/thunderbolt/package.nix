{
  lib,
  stdenv,
  boost,
  cmake,
  fetchFromGitHub,
  pkg-config,
  txt2tags,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "thunderbolt";
  version = "0.9.3";
  src = fetchFromGitHub {
    owner = "01org";
    repo = "thunderbolt-software-user-space";
    rev = "v${version}";
    sha256 = "02w1bfm7xvq0dzkhwqiq0camkzz9kvciyhnsis61c8vzp39cwx0x";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    txt2tags
    udevCheckHook
  ];
  buildInputs = [ boost ];

  cmakeFlags = [
    "-DUDEV_BIN_DIR=${placeholder "out"}/bin"
    "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
  ];

  doInstallCheck = true;

  meta = {
    description = "Thunderbolt user-space components";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ryantrinkle ];
    homepage = "https://01.org/thunderbolt-sw";
    platforms = lib.platforms.linux;
  };
}
