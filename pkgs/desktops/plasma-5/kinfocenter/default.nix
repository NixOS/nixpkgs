{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  qttools,
  kcmutils,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  kdeclarative,
  ki18n,
  kiconthemes,
  kio,
  kirigami2,
  kpackage,
  kservice,
  kwayland,
  kwidgetsaddons,
  kxmlgui,
  solid,
  systemsettings,
  dmidecode,
  fwupd,
  libraw1394,
  libusb1,
  libGLU,
  pciutils,
  smartmontools,
  util-linux,
  vulkan-tools,
  wayland-utils,
  xdpyinfo,
}:

let
  inherit (lib) getBin getExe;

  qdbus = "${getBin qttools}/bin/qdbus";

in
mkDerivation {
  pname = "kinfocenter";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    kcmutils
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdeclarative
    ki18n
    kiconthemes
    kio
    kirigami2
    kpackage
    kservice
    kwayland
    kwidgetsaddons
    kxmlgui
    solid
    systemsettings

    dmidecode
    fwupd
    libraw1394
    libusb1
    libGLU
    pciutils
    smartmontools
    util-linux
    vulkan-tools
    wayland-utils
    xdpyinfo
  ];

  patches = [
    ./0001-tool-paths.patch
  ];

  postPatch = ''
    for f in Modules/kwinsupportinfo/{kcm_kwinsupportinfo.json.in,main.cpp}; do
      substituteInPlace $f \
        --replace "@qdbus@" "${qdbus}"
    done

    for f in Modules/xserver/{kcm_xserver.json,main.cpp}; do
      substituteInPlace $f \
        --replace "@xdpyinfo@" "${getExe xdpyinfo}"
    done
  '';

  # fix wrong symlink of infocenter pointing to a 'systemsettings5' binary in
  # the same directory, while it is actually located in a completely different
  # store path
  preFixup = ''
    ln -sf ${systemsettings}/bin/systemsettings $out/bin/kinfocenter
  '';
}
