{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tuxbox";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AndyCappDev";
    repo = "tuxbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ecyt76I17lOmnB4smnwMaXCna/nJ7xcqTGelmdGdavQ=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    bleak
    evdev
    pyserial
    pyside6
  ];

  postInstall = ''
    # Copy .desktop file to output
    mkdir -p $out/share/applications/
    cp ./tuxbox-gui.desktop $out/share/applications/

    substituteInPlace $out/share/applications/tuxbox-gui.desktop \
      --replace-fail "/usr/local/bin/tuxbox-gui" "$out/bin/tuxbox-gui"

    # Install uinput udev rules
    mkdir -p $out/lib/udev/rules.d/
    echo 'KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"' > $out/lib/udev/rules.d/99-tuxbox-uinput.rules
    chmod 0744 $out/lib/udev/rules.d/99-tuxbox-uinput.rules

    # Keep ModemManager off the TourBox serial port
    cat > $out/lib/udev/rules.d/99-tuxbox-modemmanager.rules <<'EOF'
    SUBSYSTEM=="tty", ATTRS{idVendor}=="c251", ATTRS{idProduct}=="2005", ENV{ID_MM_DEVICE_IGNORE}="1"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="2e3c", ATTRS{idProduct}=="5740", ENV{ID_MM_DEVICE_IGNORE}="1"
    EOF
  '';

  meta = {
    changelog = "https://github.com/AndyCappDev/tuxbox/releases/tag/v${finalAttrs.version}";
    description = "Linux driver for all TourBox models - Native feel with USB, Bluetooth, haptics and graphical configuration GUI";
    homepage = "https://github.com/AndyCappDev/tuxbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CompileTime ];
    mainProgram = "tuxbox";
  };
})
