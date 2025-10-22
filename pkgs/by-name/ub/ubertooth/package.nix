{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libbtbb,
  libpcap,
  libusb1,
  bluez,
  udevGroup ? "ubertooth",
}:

stdenv.mkDerivation rec {
  pname = "ubertooth";
  version = "2020-12-R1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "ubertooth";
    rev = version;
    sha256 = "11r5ag2l5xn4pr7ycicm30w9c3ldn9yiqj1sqnjc79csxl2vrcfw";
  };

  sourceRoot = "${src.name}/host";

  patches = [
    # Fix cmake
    # https://github.com/greatscottgadgets/ubertooth/pull/546
    (fetchpatch {
      url = "https://github.com/greatscottgadgets/ubertooth/commit/2bf91e80b276814ab42a6025ed5d3f1e4e7a005a.patch";
      relative = "host";
      hash = "sha256-p/u67f3szrylbNaHXBDEvJPyp24teSNrwqLngLNRTAA=";
    })
    (fetchpatch {
      url = "https://github.com/greatscottgadgets/ubertooth/commit/5f60e90d5b836ee9d55fd101bc00025bf537d8ea.patch";
      relative = "host";
      hash = "sha256-yEtiy8J6Tm2zJisFgq6bUKnkgYkDbLd1L+VSaptxdiI=";
    })
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

  meta = with lib; {
    description = "Open source wireless development platform suitable for Bluetooth experimentation";
    homepage = "https://github.com/greatscottgadgets/ubertooth";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.linux;
  };
}
