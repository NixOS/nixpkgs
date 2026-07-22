{
  lib,
  buildPythonPackage,
  fetchPypi,
  libusbsio,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "libusbsio";
  # If the versions come back into sync switch back to inheriting from c lib
  # inherit (libusbsio) version;
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zs4LXyTQzrUrepp4ZEI+0rEq5F1BAXFmGaE85KLIqwA=";
  };

  # The source includes both the python module directly and also prebuilt binaries
  # Delete the binaries and patch the wrapper to use binary from Nixpkgs instead
  postPatch = ''
    rm -rf libusbsio/bin
    substituteInPlace libusbsio/libusbsio.py \
        --replace-fail \
          "dllpath = LIBUSBSIO._lookup_dll_path(dfltdir, dllname)" \
          'dllpath = "${lib.getLib libusbsio}/lib/" + dllname'
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [ libusbsio ];

  doCheck = false; # they require a device to be connected over USB

  pythonImportsCheck = [ "libusbsio" ];

  meta = {
    description = "LIBUSBSIO Host Library for USB Enabled MCUs";
    homepage = "https://www.nxp.com/design/design-center/software/development-software/libusbsio-host-library-for-usb-enabled-mcus:LIBUSBSIO";
    license = lib.licenses.bsd3;
    maintainers = [
    ];
  };
})
