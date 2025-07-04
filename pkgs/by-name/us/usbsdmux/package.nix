{
  lib,
  python3Packages,
  fetchPypi,
  udevCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "usbsdmux";
  version = "24.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OtGgToDGUr6pBu9+LS/DxaYw/9+Pd6jPhxVDAM22HB4=";
  };

  # Remove the wrong GROUP=plugdev.
  # The udev rule already has TAG+="uaccess", which is sufficient.
  postPatch = ''
    substituteInPlace contrib/udev/99-usbsdmux.rules \
      --replace-fail 'TAG+="uaccess", GROUP="plugdev"' 'TAG+="uaccess"'
  '';

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  postInstall = ''
    install -Dm0444 -t $out/lib/udev/rules.d/ contrib/udev/99-usbsdmux.rules
  '';

  meta = with lib; {
    description = "Control software for the LXA USB-SD-Mux";
    homepage = "https://github.com/linux-automation/usbsdmux";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
