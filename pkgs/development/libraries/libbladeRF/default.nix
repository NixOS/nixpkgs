{ stdenv, fetchgit, pkgconfig, cmake, git, doxygen, help2man, tecla, libusb1, udev }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "libbladeRF-v${version}";

  src = fetchgit {
    url = "https://github.com/Nuand/bladeRF/";
    rev = "refs/tags/libbladeRF_v${version}";
    sha256 = "19qd26yflig51scknyjf3r3nmnc2bni75294jpsv0idzqfj87lbr";
    name = "libbladeRF_v${version}-checkout";
  };

  buildInputs = [ pkgconfig cmake git doxygen help2man tecla libusb1 udev ];

  # Fixup shebang
  prePatch = "patchShebangs host/utilities/bladeRF-cli/src/cmd/doc/generate.bash";

  # Let us avoid nettools as a dependency.
  patchPhase = ''
    sed -i 's/$(hostname)/hostname/' host/utilities/bladeRF-cli/src/cmd/doc/generate.bash
    sed -i 's/ --no-info/ --no-info --no-discard-stderr/' host/utilities/bladeRF-cli/CMakeLists.txt
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DUDEV_RULES_PATH=$out/etc/udev/rules.d"
    "-DINSTALL_UDEV_RULES=ON"
    "-DBUILD_DOCUMENTATION=ON"
  ];

  meta = {
    homepage = "https://www.nuand.com/";
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.funfunctor ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
