<<<<<<< HEAD
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
=======
{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libftdi1
, libusb1
, udev
, hidapi
, zlib
}:

stdenv.mkDerivation rec {
  pname = "openfpgaloader";
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
<<<<<<< HEAD
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
    udev
    zlib
  ];

  meta = {
    broken = stdenv.isDarwin; # error: Package ‘systemd-253.6’ is not available on the requested Darwin platform.
    description = "Universal utility for programming FPGAs";
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ danderson ];
    platforms = lib.platforms.linux;
  };
})
=======
    rev = "v${version}";
    sha256 = "sha256-MPIFD7/jUEotY/EhuzNhaz8C3LVMxUr++fhtCpbbz0o=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libftdi1
    libusb1
    udev
    hidapi
    zlib
  ];

  meta = with lib; {
    description = "Universal utility for programming FPGAs";
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ danderson ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
