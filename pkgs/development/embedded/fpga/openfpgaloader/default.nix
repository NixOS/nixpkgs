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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OiyuhDrK4w13lRmgfmMlZ+1gvRZCJxsOF6MzLy3CFpg=";
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
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ danderson ];
    platforms = lib.platforms.unix;
  };
})
