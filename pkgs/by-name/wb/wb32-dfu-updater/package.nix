{ lib
, stdenv
, fetchFromGitHub
, cmake
, libusb1
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wb32-dfu-updater";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "WestberryTech";
    repo = "wb32-dfu-updater";
    rev = finalAttrs.version;
    hash = "sha256-DKsDVO00JFhR9hIZksFVJLRwC6PF9LCRpf++QywFO2w=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "USB programmer for downloading and uploading firmware to/from USB devices";
    longDescription = ''
      wb32-dfu-updater is a host tool used to download and upload firmware to/from WB32 MCU via USB. (wb32-dfu-updater_cli is the command line version).
    '';
    homepage = "https://github.com/WestberryTech/wb32-dfu-updater";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "wb32-dfu-updater_cli";
    platforms = platforms.all;
  };
})
