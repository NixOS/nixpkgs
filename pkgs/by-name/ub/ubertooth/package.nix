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

stdenv.mkDerivation rec {
  pname = "ubertooth";
  version = "2020-12-R1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = pname;
    rev = version;
    sha256 = "11r5ag2l5xn4pr7ycicm30w9c3ldn9yiqj1sqnjc79csxl2vrcfw";
  };

  sourceRoot = "${src.name}/host";

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

  meta = with lib; {
    description = "Open source wireless development platform suitable for Bluetooth experimentation";
    homepage = "https://github.com/greatscottgadgets/ubertooth";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.linux;
  };
}
