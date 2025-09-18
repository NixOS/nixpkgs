{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  libusb1,
  hwdata,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "usbutils";
  version = "018";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/usb/usbutils/usbutils-${version}.tar.xz";
    hash = "sha256-g/aLWbWFR1icACZugmcYZGJ1k6tDYtjIB/UO6pI8rZM=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit hwdata;
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/Homebrew/formula-patches/24a6945778381a62ecdcc1d78bcc16b9f86778c1/usbutils/portable.patch";
      hash = "sha256-spTkWURij4sPLoWtDaWVMIk81AS5W+qUUOQL1pAZEvs=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libusb1
    python3
  ];

  outputs = [
    "out"
    "man"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "python" # uses sysfs
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    moveToOutput "bin/lsusb.py" "$python"
    install -Dm555 usbreset -t $out/bin
  '';

  meta = {
    homepage = "http://www.linux-usb.org/";
    description = "Tools for working with USB devices, such as lsusb";
    maintainers = with lib.maintainers; [
      cafkafk
      chuangzhu
    ];
    license = with lib.licenses; [
      gpl2Only # manpages, usbreset
      gpl2Plus # most of the code
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "lsusb";
  };
}
