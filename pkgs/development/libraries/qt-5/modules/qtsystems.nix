{ qtModule, qtbase
, pkg-config
, bluez, udev, libevdev, xorg, mir_1 }:

qtModule {
  name = "qtsystems";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    bluez udev libevdev xorg.libX11 mir_1
  ];
}
