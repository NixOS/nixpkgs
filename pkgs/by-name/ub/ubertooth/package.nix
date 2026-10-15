{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libbtbb,
  libpcap,
  libusb1,
  bluez,
  udevGroup ? "ubertooth",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubertooth";
  version = "2020-12-R1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "ubertooth";
    rev = finalAttrs.version;
    hash = "sha256-3LG8Be2apcOkxTpIHH2yjQ6WOBiVReZPvsT2QsVTJYc=";
  };

  sourceRoot = "${finalAttrs.src.name}/host";

  patches = [
    # https://github.com/greatscottgadgets/ubertooth/pull/546
    ./fix-cmake4-build.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libbtbb
    libpcap
    libusb1
    bluez
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "-DINSTALL_UDEV_RULES=TRUE"
    "-DUDEV_RULES_PATH=etc/udev/rules.d"
    "-DUDEV_RULES_GROUP=${udevGroup}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Open source wireless development platform suitable for Bluetooth experimentation";
    homepage = "https://github.com/greatscottgadgets/ubertooth";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
