{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  xcbuild,
  cython,
  setuptools,
  hidapi,
  libusb1,
  udev,
}:

buildPythonPackage rec {
  pname = "hidapi";
  version = "0.14.0.post4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SPziU+Um0XtmP7+ZicccfvdlPO1fS+ZfFDfDE/s9vfY=";
  };

  build-system = [
    cython
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    hidapi
    libusb1
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    HIDAPI_SYSTEM_HIDAPI = true;
  };

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  pythonImportsCheck = [ "hid" ];

  meta = with lib; {
    description = "Cython interface to the hidapi from https://github.com/libusb/hidapi";
    homepage = "https://github.com/trezor/cython-hidapi";
    # license can actually be either bsd3 or gpl3
    # see https://github.com/trezor/cython-hidapi/blob/master/LICENSE-orig.txt
    license = with licenses; [
      bsd3
      gpl3Only
    ];
    maintainers = with maintainers; [
      np
      prusnak
    ];
  };
}
