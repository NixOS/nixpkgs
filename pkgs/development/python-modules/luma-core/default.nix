{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
  smbus2,
  pyftdi,
  cbor2,
  rpi-gpio,
  spidev,
}:
buildPythonPackage rec {
  pname = "luma-core";
  version = "2.5.1";

  src = fetchPypi {
    pname = "luma_core";
    inherit version;
    hash = "sha256-m4j76GiYnsRHfiEP4pk+d0p0Jdfeg3iBQQn5i+MsplM=";
  };

  build-system = [ setuptools ];
  pyproject = true;

  dependencies = [
    pillow
    smbus2
    cbor2
  ]
  ++ optional-dependencies.complete;

  optional-dependencies = {
    gpio = [ rpi-gpio ];
    spi = [ spidev ];
    ftdi = [ pyftdi ];
    complete = with optional-dependencies; gpio ++ spi ++ ftdi;
  };

  meta = {
    description = "Pillow-compatible drawing canvas library for SBCs";
    longDescription = ''
      A component library providing a Pillow-compatible drawing canvas,
      and other functionality to support drawing primitives and text-rendering
      capabilities for small displays on the Raspberry Pi and other single
      board computers.
    '';
    homepage = "https://luma-core.readthedocs.io/";
    changelog = "https://github.com/rm-hull/luma.core/blob/${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eymeric ];
  };
}
