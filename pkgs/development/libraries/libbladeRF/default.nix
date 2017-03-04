{ stdenv, fetchFromGitHub, pkgconfig, cmake, git, doxygen, help2man, tecla
, libusb1, udev }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "libbladeRF-v${version}";

  src = fetchFromGitHub {
    owner = "Nuand";
    repo = "bladeRF";
    rev = "libbladeRF_v${version}";
    sha256 = "1y00hqsmqaix4dql8mb75zx87zvn8b483yxv53x9qyjspksbs60c";
  };

  buildInputs = [ pkgconfig cmake git doxygen help2man tecla libusb1 udev ];

  # Fixup shebang
  prePatch = "patchShebangs host/utilities/bladeRF-cli/src/cmd/doc/generate.bash";

  # Let us avoid nettools as a dependency.
  patchPhase = ''
    sed -i 's/$(hostname)/hostname/' host/utilities/bladeRF-cli/src/cmd/doc/generate.bash
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DUDEV_RULES_PATH=etc/udev/rules.d"
    "-DINSTALL_UDEV_RULES=ON"
    "-DBUILD_DOCUMENTATION=ON"
  ];

  meta = with stdenv.lib; {
    homepage = https://www.nuand.com/;
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ funfunctor ];
    platforms = platforms.linux;
  };
}
