{ stdenv, fetchgit, pkgconfig, cmake, git, libusb1, udev  }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "libbladeRF-v${version}";

  src = fetchgit {
    url = "https://github.com/Nuand/bladeRF/";
    rev = "refs/tags/libbladeRF_v${version}";
    sha256 = "19qd26yflig51scknyjf3r3nmnc2bni75294jpsv0idzqfj87lbr";
    name = "libbladeRF_v${version}-checkout";
  };

  buildInputs = [ pkgconfig cmake git libusb1 udev ];

  # TODO: Fix upstream, Documentation fails to build when pandoc is
  #       in PATH with the following errors:
  # error: 'CLI_CMD_HELPTEXT_*' undeclared here (not in a function)

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DUDEV_RULES_PATH=$out/etc/udev/rules.d"
    "-DINSTALL_UDEV_RULES=ON"
    "-DBUILD_BLADERF_CLI_DOCUMENTATION=OFF"
  ];

  meta = {
    homepage = "https://www.nuand.com/";
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.funfunctor ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
