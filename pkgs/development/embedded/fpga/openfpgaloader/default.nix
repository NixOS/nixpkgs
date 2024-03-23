{
  cmake
, fetchFromGitHub
, hidapi
, lib
, libftdi1
, libusb1
, pkg-config
, stdenv
, udev
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openfpgaloader";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fe0g8+q/4r7h++7/Bk7pbOJn1CsAc+2IzXN6lqtY2vY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hidapi
    libftdi1
    libusb1
    zlib
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform udev) [
    udev
  ];

  meta = {
    description = "Universal utility for programming FPGAs";
    mainProgram = "openFPGALoader";
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ danderson ];
    platforms = lib.platforms.unix;
  };
})
