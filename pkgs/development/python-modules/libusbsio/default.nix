{
  lib,
  buildPythonPackage,
  fetchPypi,
  libusbsio,
}:

buildPythonPackage rec {
  pname = "libusbsio";
  format = "setuptools";
  version = "2.1.12";
  # If the versions come back into sync switch back to inheriting from c lib
  # inherit (libusbsio) version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RdUhwilBOwg19ay3Po3zsxqlBV9FTy3btJDbO4YEKS8=";
  };

  # The source includes both the python module directly and also prebuilt binaries
  # Delete the binaries and patch the wrapper to use binary from Nixpkgs instead
  postPatch = ''
    rm -rf libusbsio/bin
    substituteInPlace libusbsio/libusbsio.py \
        --replace "dllpath = LIBUSBSIO._lookup_dll_path(dfltdir, dllname)" 'dllpath = "${libusbsio}/lib/" + dllname'
  '';

  buildInputs = [ libusbsio ];

  doCheck = false; # they require a device to be connected over USB

  pythonImportsCheck = [ "libusbsio" ];

  meta = with lib; {
    description = "LIBUSBSIO Host Library for USB Enabled MCUs";
    homepage = "https://www.nxp.com/design/design-center/software/development-software/libusbsio-host-library-for-usb-enabled-mcus:LIBUSBSIO";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      frogamic
      sbruder
    ];
  };
}
