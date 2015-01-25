{ stdenv, fetchgit, pkgconfig, libftdi, libusb, udev, cmake, git }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "libbladeRF-v${version}";

  src = fetchgit {
    url = "https://github.com/Nuand/bladeRF/";
    rev = "refs/tags/libbladeRF_v${version}";
    sha256 = "19qd26yflig51scknyjf3r3nmnc2bni75294jpsv0idzqfj87lbr";
    name = "libbladeRF_v${version}-checkout";
  };

  buildInputs = [ pkgconfig libftdi libusb udev cmake git ];

# XXX: documentation fails to build due to a "undeclared here" bug.
#      requires pandoc in buildInputs also..
# YYY: udev rule wont install to "/etc/udev/rules.d/88-nuand.rules"???
  configurePhase = ''
    cmake -DCMAKE_BUILD_TYPE=Debug -DINSTALL_UDEV_RULES=OFF \
          -DBUILD_BLADERF_CLI_DOCUMENTATION=OFF -DCMAKE_INSTALL_PREFIX=$out .
  '';

  meta = {
    homepage = "https://www.nuand.com/";
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.funfunctor ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
