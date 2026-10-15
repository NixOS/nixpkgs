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

stdenv.mkDerivation (finalAttrs: {
  pname = "thunderbolt";
  version = "0.9.3";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "thunderbolt-software-user-space";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HXTO0rh/IxaMjtpCH9me6f9ZFQM4Yg7nbwDvfqpbgQs=";
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
})
